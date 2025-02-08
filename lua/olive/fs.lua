local deque = require("olive.utils.deque")

local M = {}

local function traverse_fs()
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

function M.get_files()
    local files = traverse_fs()
    table.sort(files, function(a, b)
        return a.full_path < b.full_path
    end)

    return files
end

return M
