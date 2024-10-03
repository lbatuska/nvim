-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide == true then
  vim.api.nvim_set_keymap("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
  vim.g.neovide_fullscreen = true
  vim.g.neovide_hide_mouse_when_typing = true
end

if vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1 then
  require("nvim-treesitter.install").prefer_git = false
end

--- Find clangd
local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  else
    return false
  end
end

local clangd_paths = {
  "/usr/sbin/clangd",
  "/usr/bin/clangd",
}

local clangd_cmd = nil
for _, path in ipairs(clangd_paths) do
  if file_exists(path) then
    clangd_cmd = path
    break
  end
end

local lspconfig = require("lspconfig")
if clangd_cmd then
  vim.notify("Clangd found in: " .. clangd_cmd)
  lspconfig.clangd.setup({
    cmd = { clangd_cmd },
  })
else
  vim.notify("Clangd not found in /usr/sbin or /usr/bin", vim.log.levels.WARN)
end
--- Find clangd

--- MASON PACKAGES ---

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = { "zls", "omnisharp", "asm_lsp", "gopls" },
})

local mason_registry = require("mason-registry")

local function ensure_tool_installed(tool_name)
  if not mason_registry.is_installed(tool_name) then
    vim.cmd("MasonInstall " .. tool_name)
  end
end

local non_lsp_tools = {
  "clang-format",
  "cmakelang",
  "cmakelint",
  "codelldb",
  "csharpier",
  "delve",
  "debugpy",
  "sqlfluff",
  "gofumpt",
  "goimports",
  "shfmt",
  "stylua",
  "shellcheck",
  "neocmakelsp",
  "htmx-lsp",
  "bash-language-server",
  "ansible-language-server",
  "yaml-language-server",
  "yamlfix",
  "yamlfmt",
  "yamllint",
  "gitlab-ci-ls",
}

for _, tool in ipairs(non_lsp_tools) do
  ensure_tool_installed(tool)
end

--- MASON PACKAGES ---

-- require("catppuccin").setup({
--   flavour = "mocha",
-- })
-- vim.cmd.colorscheme("catppuccin")

vim.g.moonflyCursorColor = true
vim.g.moonflyItalics = false
vim.g.moonflyVirtualTextColor = true
vim.g.moonflyWinSeparator = 2
vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
  eob = " ",
}

vim.g.moonflyNormalFloat = true
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
  border = "single",
})
vim.diagnostic.config({ float = { border = "single" } })

local winhighlight = {
  winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
}

local cmp = require("cmp")

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(winhighlight),
    documentation = cmp.config.window.bordered(winhighlight),
  },
})

vim.cmd.colorscheme("moonfly")

vim.filetype.add({
  pattern = {
    -- ansible playbook
    [".*/.*playbook.*.ya?ml"] = "yaml.ansible",
    [".*/.*tasks.*/.*ya?ml"] = "yaml.ansible",
    [".*/.*plays.*/.*ya?ml"] = "yaml.ansible",
    [".*/ansible/.*%.ya?ml"] = "yaml.ansible",
  },
})

vim.o.modeline = true
vim.o.modelines = 5

if vim.fn.getenv("TMUX") ~= vim.NIL then
  -- We're in a TMUX session, configure TMUX
  vim.fn.system("tmux unbind -a") -- Unbind all keys
  vim.fn.system("tmux set-option -g prefix None") -- Disable the TMUX prefix
  vim.fn.system("tmux bind-key -n C-q detach") -- Bind Ctrl-q to detach from TMUX
end
