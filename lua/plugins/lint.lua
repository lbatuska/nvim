return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Assign linters to filetypes
    lint.linters_by_ft = {
      cpp = { "cpplint" },
      c = { "cpplint" },
      sql = { "sqlfluff" },
    }

    -- Configure sqlfluff manually (optional, if Mason already handles it fine)
    lint.linters.sqlfluff = {
      cmd = "sqlfluff",
      stdin = false,
      args = {
        "lint",
        "--format=json",
        "--dialect=postgres",
      },
      stream = "stdout",
      ignore_exitcode = true,
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %m"),
    }

    -- Optional: Configure cpplint (if not auto-detected correctly)
    lint.linters.cpplint = {
      cmd = "cpplint",
      stdin = false,
      args = { "--filter= -build/include_subdir, -legal/copyright, -build/include_order" },
      stream = "stderr",
      ignore_exitcode = true,
      parser = require("lint.parser").from_errorformat("%f:%l:  %m"),
    }

    -- Auto-run linters on save
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}

-- return {
--   "mfussenegger/nvim-lint",
--   opts = {
--     linters = {
--       sqlfluff = {
--         args = {
--           "lint",
--           "--format=json",
--           "--dialect=postgres",
--         },
--       },
--     },
--   },
-- }
