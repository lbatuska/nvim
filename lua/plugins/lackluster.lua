if true then
  return {}
else
  return {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    -- vim.cmd.colorscheme("lackluster")
    -- vim.cmd.colorscheme("lackluster-hack")
    -- vim.cmd.colorscheme("lackluster-mint")
  }
end
