return {
  "HiPhish/jinja.vim",
  ft = { "jinja", "jinja.html", "jinja2" },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "jinja", "jinja.html", "jinja2" },
      command = "syntax enable",
    })
  end,
}
