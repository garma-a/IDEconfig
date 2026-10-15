-- Neovim -l disables loadplugins; enable it before initializing Lazy.
vim.opt.loadplugins = true
-- Exercise real server startup in a temporary project; no user project is touched.
local repo = assert(vim.env.IDE_SETUP_REPO)
vim.opt.rtp:prepend(repo)
dofile(repo .. "/init.lua")
vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })
local project = vim.fn.tempname()
vim.fn.mkdir(project .. "/.git", "p")
vim.fn.writefile({ '{"compilerOptions":{"noEmit":true},"include":["*.ts"]}' }, project .. "/tsconfig.json")
vim.fn.writefile({ '{"name":"setup-smoke","private":true}' }, project .. "/package.json")
vim.fn.writefile({ "module setup-smoke", "", "go 1.26" }, project .. "/go.mod")
vim.fn.writefile({ '<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><TargetFramework>net10.0</TargetFramework></PropertyGroup></Project>' }, project .. "/smoke.csproj")
local cases = {
  { "ts_ls", "main.ts", { 'const greeting: string = "hello";' } },
  { "pyright", "main.py", { 'greeting: str = "hello"' } },
  { "lua_ls", "main.lua", { 'local greeting = "hello"', "print(greeting)" } },
  { "zls", "main.zig", { "pub fn main() void {}" } },
  { "gopls", "main.go", { "package main", "func main() {}" } },
  { "csharp_ls", "Example.cs", { "public class Example {}" } },
  { "dbml", "schema.dbml", { "Table example {", "  id int [pk]", "}" } },
}
local ok, err = xpcall(function()
  for _, case in ipairs(cases) do
    local server, filename, contents = unpack(case)
    local path = project .. "/" .. filename
    vim.fn.writefile(contents, path)
    vim.cmd("edit " .. vim.fn.fnameescape(path))
    local bufnr = vim.api.nvim_get_current_buf()
    local attached = vim.wait(30000, function()
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = server })) do
        if client.initialized then return true end
      end
      return false
    end, 100)
    assert(attached, "Language server did not attach: " .. server .. ". See :LspLog")
    print("LSP attached: " .. server)
    if server == "ts_ls" then
      local client = vim.lsp.get_clients({ bufnr = bufnr, name = server })[1]
      local response = client:request_sync("textDocument/hover", {
        textDocument = { uri = vim.uri_from_bufnr(bufnr) }, position = { line = 0, character = 7 },
      }, 15000, bufnr)
      assert(response and not response.err, "TypeScript server did not answer a hover request")
    end
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do client:stop() end
    vim.wait(5000, function() return #vim.lsp.get_clients({ bufnr = bufnr }) == 0 end, 50)
    vim.cmd("bwipeout!")
  end
end, debug.traceback)
for _, client in ipairs(vim.lsp.get_clients()) do client:stop(true) end
vim.fn.delete(project, "rf")
if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
end
print("Verified representative language servers start and attach.")
vim.cmd("qa!")
