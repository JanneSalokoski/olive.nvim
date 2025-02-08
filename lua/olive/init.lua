-- olive.lua - entry point to the plugin

local fs = require("olive.fs")
local render = require("olive.render")

local M = {}

local function create_buffer()
    -- Create a buffer for olive

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        -- Return early if the buffer already exists
        if vim.api.nvim_buf_get_name(buf) == "Olive" then
            vim.api.nvim_set_current_buf(buf)
            return buf
        end
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "Olive")

    vim.cmd("split")
    vim.api.nvim_set_current_buf(buf)

    return buf
end

local function set_autocommands()
    -- Set autocommands for olive

    vim.api.nvim_create_autocmd("TextYankPost", {
        -- Handle whenever a yank happens
        pattern = "Olive",
        callback = function()
            vim.notify("Line(s) were yanked")
            local yanked_lines = vim.fn.getreg('"', 1)
            vim.notify(vim.inspect(yanked_lines))
        end
    })

    vim.api.nvim_create_autocmd("TextChanged", {
        -- Handle when text changes in normal mode
        pattern = "Olive",
        callback = function()
            vim.notify("Text has changed in normal mode! Is it a paste?")
        end
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        -- Handle when the buffer is entered
        pattern = "Olive",
        callback = function()
            vim.print("Buffer created")
        end
    })
end

local function set_hl_groups()
    -- todo: set some reasonable color
    vim.api.nvim_set_hl(0, "OlivePath", { fg = "#ff0000" })
    vim.api.nvim_set_hl(0, "OliveMeta", { fg = "#00ff00" })
end


function M.open()
    -- Initialize an olive buffer

    local buf = create_buffer()
    local files = fs.get_files()
    local ns = vim.api.nvim_create_namespace("olive")

    for i, file in ipairs(files) do
        render.render_files(buf, files, ns)
    end
end

function M.setup()
    -- Setup olive

    set_autocommands()
    set_hl_groups()
end

return M
