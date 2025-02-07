-- olive.lua - entry point to the plugin

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

local function list_files_in_cwd()
    local cwd = vim.loop.cwd()
    local files = {}

    local dir = vim.loop.fs_scandir(cwd)
    if dir then
        while true do
            local name, type = vim.loop.fs_scandir_next(dir)
            if not name then
                break
            end
            table.insert(files, { name = name, type = type })
        end
    end

    return files
end

function M.open()
    -- Initialize an olive buffer

    local buf = create_buffer()

    local files = list_files_in_cwd()

    local file_strings = {}
    for i, file in ipairs(files) do
        table.insert(file_strings, string.format("%i: %s (%s)", i, file.name, file.type))
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, file_strings)
end

function M.setup()
    -- Setup olive

    set_autocommands()
end

return M
