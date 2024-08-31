-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local lspconfig = require("lspconfig")
lspconfig.clangd.setup({
  cmd = { "/usr/sbin/clangd" },
})

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = {}, -- Empty list, to prevent any automatic installation
})

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
