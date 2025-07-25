-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide == true then
  vim.api.nvim_set_keymap("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
  -- vim.g.neovide_fullscreen = true
  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.1)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.1)
  end)
end

-- WSL2 won't work with git for some reason
if vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1 then
  require("nvim-treesitter.install").prefer_git = false
end

vim.opt.colorcolumn = { 80, 100 }

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
    cmd = {
      clangd_cmd,
      "--background-index",
      "--clang-tidy",
      "--enable-config",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=google",
      "--clang-tidy-checks=modernize-*,-modernize-use-trailing-return-type",
    },
  })
else
  vim.notify("Clangd not found in /usr/sbin or /usr/bin", vim.log.levels.WARN)
end
--- Find clangd

lspconfig.postgres_lsp.setup({})

--- MASON PACKAGES ---

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = { "zls", "omnisharp", "asm_lsp", "gopls", "ruff" },
  automatic_installation = true,
})

local mason_registry = require("mason-registry")

local function ensure_tool_installed(tool_name)
  if not mason_registry.is_installed(tool_name) then
    vim.cmd("MasonInstall " .. tool_name)
  end
end

local non_lsp_tools = {
  "clang-format", -- 19.1.7  clangd -- 19.1.2
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
  "yamlfix",
  "yamlfmt",
  "yamllint",
  "gitlab-ci-ls",
  "autotools-language-server",
  "cmake-language-server",
  "asmfmt",
  "jinja-lsp",
  "postgrestools",
  "cpplint",
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
-- Add a single line border to improve the visual experience
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
  border = "single",
})

vim.diagnostic.config({ float = { border = "single" } })
-- consistent highlight groups for floating windows
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

-- There were some errors using zig before LazyExtras added it, uncomment if lsp you get completion errors when coding or no completion
-- cmp.setup.filetype("zig", {
--   sources = cmp.config.sources({
--     { name = "nvim_lsp" },
--     { name = "buffer" },
--     { name = "path" },
--   }),
-- })

-- Seems to break .clang-format files
-- local conform = require("conform")
-- conform.setup({
--   formatters_by_ft = {
--     c = { "clang_format" },
--     cpp = { "clang_format" },
--     -- Add more filetypes as needed
--   },
--   formatters = {
--     clang_format = {
--       prepend_args = { "--style=Google" },
--     },
--   },
-- })

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
  vim.fn.system("tmux set -g mouse on")
  vim.fn.system("set-option -g set-clipboard on")
end

vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
