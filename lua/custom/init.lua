
require("custom.settings")
require("custom.remap")

require("custom.lazy")

vim.cmd[[colorscheme tokyonight-night]]

vim.cmd [[ autocmd BufRead,BufNewFile *.yml set filetype=yaml.ansible ]]
vim.cmd [[ autocmd BufRead,BufNewFile *.yaml set filetype=yaml.ansible ]]
