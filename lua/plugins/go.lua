if true then
  return {}
else
  return {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      { "nvim-treesitter/nvim-treesitter", branch = "main" },
    },
    opts = function()
      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })
      return {
        -- lsp_keymaps = false,
      }
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
  }
end
