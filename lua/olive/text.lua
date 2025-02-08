local M = {}

function M.write_text(text, buf, line)
    if type(text) == "string" then
        text = { text }
    end

    vim.print(line)
    vim.api.nvim_buf_set_lines(buf, line, -1, false, text)
end

function M.write_virtual_overlay(text, buf, ns, line)
    print(line)
    vim.api.nvim_buf_set_extmark(buf, ns, line, -1, {
        virt_text = { { text, "OlivePath" } },
        virt_text_pos = "overlay",
        virt_text_win_col = 0,
    })
end

function M.write_virtual_right(text, buf, ns, line)
    vim.api.nvim_buf_set_extmark(buf, ns, line, 0, {
        virt_text = { { text, "OliveMeta" } },
        virt_text_pos = "right_align"
    })
end

return M
