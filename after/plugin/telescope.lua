-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      hidden = true,
    },
  },
  pickers = {
    find_files = {
      hidden = true
    },
  }
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"

-- open file_browser with the path of the current buffer (hidden=true can be skipped as it's in setup already)
vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>",
  { noremap = true }
)
-- find file (add cwd = '%:p:h' for only current folder, eg: { find_command = {'rg', '--files', '-g', '!.git' }, cwd = '%:p:h' })
vim.api.nvim_set_keymap(
  "n",
  "<space>ff",
  "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '-g', '!.git' } })<cr>",
  { noremap = true }
)
