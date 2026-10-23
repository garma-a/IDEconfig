-- Neovim -l disables loadplugins; enable it before initializing Lazy.
vim.opt.loadplugins = true
-- Start with -l (no user init) so restore finishes before plugin configurations run.
local repo = assert(vim.env.IDE_SETUP_REPO, "IDE_SETUP_REPO is required")
vim.opt.rtp:prepend(repo)
local lock_lines = vim.fn.readfile(repo .. "/lazy-lock.json")
local expected_lock = vim.json.decode(table.concat(lock_lines, "\n"))
local failures = {}
local notify = vim.notify
vim.notify = function(message, level, opts)
  if level == vim.log.levels.ERROR then
    table.insert(failures, tostring(message))
  end
  notify(message, level, opts)
end
local ok, err = xpcall(function()
  require("config.globals")
  require("config.lazy")
  local lazy = require("lazy")
  -- Auto-install may update the lockfile. Restore the source pins before restore.
  vim.fn.writefile(lock_lines, repo .. "/lazy-lock.json")
  local lock = require("lazy.manage.lock")
  lock._loaded = false
  lock.load()
  local restore = {}
  for name, pin in pairs(expected_lock) do
    local plugin = assert(require("lazy.core.config").plugins[name], "Locked plugin missing from spec: " .. name)
    local head = vim.fn.system({ "git", "-C", plugin.dir, "rev-parse", "HEAD" })
    if vim.trim(head) ~= pin.commit then table.insert(restore, name) end
  end
  if #restore > 0 then lazy.restore({ plugins = restore, wait = true, show = false }) end
  vim.fn.writefile(lock_lines, repo .. "/lazy-lock.json")
  for name, plugin in pairs(require("lazy.core.config").plugins) do
    for _, task in ipairs(plugin._.tasks or {}) do
      assert(not task:has_errors(), "Plugin task failed: " .. name)
    end
  end
  lazy.load({ plugins = { "nvim-lspconfig", "nvim-treesitter" } })
  local registry = require("mason-registry")
  local refreshed, refresh_ok = false, false
  registry.refresh(function(success)
    refreshed, refresh_ok = true, success
  end)
  assert(vim.wait(300000, function() return refreshed end, 100), "Mason registry refresh timed out")
  assert(refresh_ok, "Mason registry refresh failed")
  local tools = require("config.tools")
  local pending, install_failures = 0, {}
  for _, entry in ipairs(tools) do
    local name = type(entry) == "table" and entry[1] or entry
    local version = type(entry) == "table" and entry.version or nil
    print("Mason: " .. name .. (version and ("@" .. version) or ""))
    local pkg = registry.get_package(name)
    local needs_install = not pkg:is_installed()
    if version and pkg:is_installed() then
      local receipt = pkg:get_receipt():get()
      needs_install = not (receipt.source.id or ""):match("@" .. vim.pesc(version) .. "$")
    end
    if needs_install then
      pending = pending + 1
      -- Mason's own semaphore limits concurrent installers (four by default).
      pkg:install({ version = version }, function(installed)
        pending = pending - 1
        if not installed then table.insert(install_failures, name) end
      end)
    end
  end
  assert(vim.wait(1800000, function() return pending == 0 end, 100), "Mason installations timed out. See :MasonLog")
  assert(#install_failures == 0, "Mason installs failed: " .. table.concat(install_failures, ", ") .. ". See :MasonLog")
  -- Avoid stalled HTTP/2 archive downloads and bound each network attempt.
  require("nvim-treesitter.install").command_extra_args.curl = {
    "--http1.1", "--connect-timeout", "20", "--max-time", "180", "--retry", "3",
  }
  local parsers = require("plugins.treesitter")[1].opts.ensure_installed
  local missing = vim.deepcopy(parsers)
  for attempt = 1, 3 do
    require("nvim-treesitter.install").ensure_installed_sync(missing)
    missing = {}
    for _, lang in ipairs(parsers) do
      if not pcall(vim.treesitter.language.add, lang) then table.insert(missing, lang) end
    end
    if #missing == 0 then break end
    print("Retrying missing parsers (attempt " .. attempt .. "): " .. table.concat(missing, ", "))
    vim.wait(2000)
  end
  assert(#missing == 0, "Parsers missing after retries: " .. table.concat(missing, ", "))
  -- Check configurations and all normal keymaps after installation.
  dofile(repo .. "/init.lua")
  assert(#failures == 0, table.concat(failures, "\n"))
end, debug.traceback)
if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
else
  print("Neovim plugins, language tools and parsers installed.")
  vim.cmd("qa!")
end
