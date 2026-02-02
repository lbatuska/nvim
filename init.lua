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

-- local clangd_cmd = nil
local clangd_cmd = vim.fn.stdpath("data") .. "/mason/bin/clangd"

if not vim.fn.executable(clangd_cmd) then
  for _, path in ipairs(clangd_paths) do
    if file_exists(path) then
      clangd_cmd = path
      break
    end
  end
end

if clangd_cmd then
  vim.notify("Clangd found in: " .. clangd_cmd)
  vim.lsp.config("clangd", {
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
  vim.lsp.enable("clangd")
else
  vim.notify("Clangd not found in mason, /usr/sbin, or /usr/bin", vim.log.levels.WARN)
end

--- Find clangd

local cmake_ls_cmd = (function()
  local mason_cmd = vim.fn.stdpath("data") .. "/mason/bin/cmake-language-server"
  if vim.fn.executable(mason_cmd) == 1 then
    return mason_cmd
  elseif vim.fn.executable("/usr/bin/cmake-language-server") == 1 then
    return "/usr/bin/cmake-language-server"
  elseif vim.fn.executable("cmake-language-server") == 1 then
    return "cmake-language-server"
  else
    return nil
  end
end)()

if cmake_ls_cmd == nil then
  vim.notify("cmake-language-server not found (checked mason and /usr/bin)", vim.log.levels.WARN)
else
  vim.notify("cmake-language-server found in: " .. cmake_ls_cmd, vim.log.levels.INFO)
  vim.lsp.config("cmake-language-server", { cmd = { cmake_ls_cmd }, filetypes = { "cmake" } })
  vim.lsp.enable("cmake-language-server")
end

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
  "asmfmt",
  "jinja-lsp",
  "postgres-language-server",
  "cpplint",
  "docker-language-server",
}

for _, tool in ipairs(non_lsp_tools) do
  ensure_tool_installed(tool)
end

--- MASON PACKAGES ---

-- vim.g.moonflyCursorColor = true
-- vim.g.moonflyItalics = false
-- vim.g.moonflyVirtualTextColor = true
-- vim.g.moonflyWinSeparator = 2
-- vim.opt.fillchars = {
--   horiz = "━",
--   horizup = "┻",
--   horizdown = "┳",
--   vert = "┃",
--   vertleft = "┫",
--   vertright = "┣",
--   verthoriz = "╋",
--   eob = " ",
-- }
--
-- vim.g.moonflyNormalFloat = true
--
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.config("textDocument/hover", { border = "single" })
--
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.config("textDocument/signatureHelp", { border = "single" })
--
-- vim.diagnostic.config({ float = { border = "single" } })
-- -- consistent highlight groups for floating windows
-- local winhighlight = {
--   winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
-- }
--
-- local cmp = require("cmp")
--
-- cmp.setup({
--   window = {
--     completion = cmp.config.window.bordered(winhighlight),
--     documentation = cmp.config.window.bordered(winhighlight),
--   },
-- })
--
-- vim.cmd.colorscheme("moonfly")

-- vim.cmd.colorscheme("no-clown-fiesta")
-- vim.cmd.colorscheme("lackluster-hack")

vim.opt.termguicolors = true
vim.opt.background = "dark"

-- vim.cmd.colorscheme("monochrome")

vim.cmd.colorscheme("alabaster")
vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@function", { link = "Function" })
vim.api.nvim_set_hl(0, "@type", { link = "Type" })
vim.api.nvim_set_hl(0, "@keyword", { link = "Keyword" })
vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })

vim.api.nvim_set_hl(0, "Normal", { bg = "#000000", fg = "#dcdcdc" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#707070", italic = true })
vim.api.nvim_set_hl(0, "String", { fg = "#b0b0b0" })

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#3a3a3a" })

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
