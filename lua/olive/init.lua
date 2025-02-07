-- olive.lua - entry point to the plugin

local deque = require("olive.utils.deque")

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

local function traverse()
    local files = {}

    local queue = deque.new()
    deque.pushright(queue, ".")

    local root = deque.popleft(queue)
    while root do
        local dir = vim.loop.fs_scandir(root)
        while true do
            local name, type = vim.loop.fs_scandir_next(dir)
            if not name then
                break
            end

            local path = root .. "/" .. name
            local stat = vim.loop.fs_stat(path)

            local entry = {
                name = name,
                path = root,
                full_path = path,
                type = type,
                size = stat.size,
                permissions = stat.mode % 512, -- remove filetype bits from the start
                modified = stat.mtime.sec,
                created = stat.birthtime.sec,
            }

            table.insert(files, entry)

            if type == "directory" then
                deque.pushright(queue, path)
            end
        end

        root = deque.popleft(queue)
    end

    return files
end

function M.open()
    -- Initialize an olive buffer

    local buf = create_buffer()

    -- local files = list_files_in_cwd()
    local files = traverse()
    table.sort(files, function(a, b)
        return a.full_path < b.full_path
    end)

    local ns = vim.api.nvim_create_namespace("olive")

    local file_strings = {}
    for i, file in ipairs(files) do
        -- todo: We can have two different modes:
        --          1) Tab indented mode
        --          2) Virtual text path mode

        table.insert(file_strings, file_string)

        -- string.format(
        --     "%o\t%i\t%i\t%06i\t\t%s/%s\t%s",
        --     file.permissions,
        --     file.created,
        --     file.modified,
        --     file.size,
        --     file.path,
        --     file.name,
        --     file.type

        local virt_text = string.format("%s", file.path .. "/")
        local virt_text_len = #virt_text

        -- This is only for the tab mode
        -- local indent_level = select(2, string.gsub(file.path, "/", ""))
        -- local tabs = string.rep("\t", indent_level)

        local padding = string.rep(" ", virt_text_len)

        local file_string = string.format("%s%s", padding, file.name)
        vim.api.nvim_buf_set_lines(buf, i - 1, -1, false, { file_string })

        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, -1, {
            virt_text = { { virt_text, "OlivePath" } },
            virt_text_pos = "overlay",
            virt_text_win_col = 0,
        })

        local meta_text = string.format(
            "%o\t%i\t%i\t%06i",
            file.permissions,
            file.created,
            file.modified,
            file.size
        )

        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
            virt_text = { { meta_text, "OliveMeta" } },
            virt_text_pos = "right_align",
        })
    end
end

function M.setup()
    -- Setup olive

    set_autocommands()
    set_hl_groups()
end

return M
