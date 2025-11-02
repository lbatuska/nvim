return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      cpp = { "cpplint" },
      c = { "cpplint" },
      sql = { "sqlfluff" },
    }

    lint.linters.sqlfluff = {
      name = "sqlfluff",
      cmd = "sqlfluff",
      stdin = false,
      args = {
        "lint",
        "--format=json",
        "--dialect=postgres",
      },
      stream = "stderr",
      ignore_exitcode = true,
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {}),
    }

    lint.linters.cpplint = {
      name = "cpplint",
      cmd = "cpplint",
      stdin = false,
      args = {
        "--linelength=35", -- -whitespace ignores this rule
        "--filter=-build/include_subdir,-legal/copyright,-build/include_order,-whitespace,-readability/todo,-build/c++11,-build/c++17",
      },
      stream = "stderr",
      ignore_exitcode = true,
      parser = require("lint.parser").from_errorformat("%f:%l:  %m", {}),
    }

    -- Auto-run linters on save
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
