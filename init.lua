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

-- if vim.fn.has("wsl") == 1 then
--   vim.api.nvim_create_autocmd("TextYankPost", {
--     callback = function()
--       vim.schedule(function()
--         vim.fn.systemlist("clip.exe", vim.fn.getreg("0"))
--       end)
--     end,
--   })
-- end
