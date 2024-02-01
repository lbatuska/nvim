
-- Go to definition on new tab

vim.keymap.set('n', 'gD', function()
        local org_path = vim.api.nvim_buf_get_name(0)

        -- Go to definition:
        vim.api.nvim_command('normal gd')

        -- Wait LSP server response
        vim.wait(100, function() end)

        local new_path = vim.api.nvim_buf_get_name(0)
        if not (org_path == new_path) then
            -- Create a new tab for the original file
            vim.api.nvim_command('0tabnew %')

            -- Restore the cursor position
            vim.api.nvim_command('b ' .. org_path)
            vim.api.nvim_command('normal! `"')

            -- Switch to the original tab
            vim.api.nvim_command('normal! gt')
        end
    end, bufopts)
