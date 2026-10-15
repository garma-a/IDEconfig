-- Neovim -l disables loadplugins; enable it before initializing Lazy.
vim.opt.loadplugins = true
local repo = assert(vim.env.IDE_SETUP_REPO, "IDE_SETUP_REPO required")
vim.opt.rtp:prepend(repo)
local startup_errors = {}
local notify = vim.notify
vim.notify = function(message, level, opts)
  if level == vim.log.levels.ERROR then table.insert(startup_errors, tostring(message)) end
  notify(message, level, opts)
end
local started, startup_error = pcall(function()
  dofile(repo .. "/init.lua")
  vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })
end)
if not started then
  io.stderr:write(tostring(startup_error) .. "\n")
  vim.cmd("cquit 1")
end
local failures = {}
local function check(condition, message)
  if not condition then table.insert(failures, message) end
end
check(vim.fn.has("nvim-0.11.3") == 1, "Neovim >=0.11.3 required")
check(vim.v.errmsg == "", vim.v.errmsg)
check(#startup_errors == 0, table.concat(startup_errors, "\n"))
local registry = require("mason-registry")
for _, entry in ipairs(require("config.tools")) do
  local name = type(entry) == "table" and entry[1] or entry
  local ok, pkg = pcall(registry.get_package, name)
  check(ok and pkg:is_installed(), "Mason package missing: " .. name)
end
for _, tool in ipairs(require("go.install").tools) do
  check(vim.fn.executable(tool) == 1, "Go helper missing: " .. tool)
end
for _, lang in ipairs(require("plugins.treesitter")[1].opts.ensure_installed) do
  check(pcall(vim.treesitter.language.add, lang), "Treesitter parser missing: " .. lang)
end
local lock = vim.json.decode(table.concat(vim.fn.readfile(repo .. "/lazy-lock.json"), "\n"))
for name, pin in pairs(lock) do
  local plugin = require("lazy.core.config").plugins[name]
  check(plugin ~= nil and vim.fn.isdirectory(plugin.dir) == 1, "Plugin missing: " .. name)
  if plugin then
    local commit = vim.fn.system({ "git", "-C", plugin.dir, "rev-parse", "HEAD" }):gsub("%s+$", "")
    check(commit == pin.commit, "Plugin differs from lockfile: " .. name)
  end
end
for _, name in ipairs({ "html", "cssls", "gopls", "yamlls", "dockerls", "prismals", "csharp_ls", "zls", "graphql", "pyright", "clangd", "lua_ls", "ts_ls", "dbml" }) do
  check(vim.lsp.is_enabled(name), "LSP not enabled: " .. name)
end
check(vim.fn.maparg("<leader>sf", "n") ~= "", "File search shortcut missing")
if #failures > 0 then
  io.stderr:write(table.concat(failures, "\n") .. "\n")
  vim.cmd("cquit 1")
end
print("Verified Neovim lockfile, Mason tools, parsers, LSP configurations and shortcuts.")
vim.cmd("qa!")
