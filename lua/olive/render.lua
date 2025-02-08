local text = require("olive.text")
local size = require("olive.utils.size")

local M = {}

-- This should come from options
local time_format = "%H:%M"

local function get_meta_text(file)
    local created = os.date(time_format, file.created)
    local modified = os.date(time_format, file.modified)
    local filesize = size.format(file.size)

    local meta_text = string.format(
        "%-6o%-8s%-8s%-8s",
        file.permissions,
        created,
        modified,
        filesize
    )

    return meta_text
end

function M.render_files(buf, files, ns)
    for i, file in ipairs(files) do
        local path_text = string.format("%s", file.path .. "/")
        local padding = string.rep(" ", #path_text)
        local normal_text = string.format("%s%s", padding, file.name)
        local meta_text = get_meta_text(file)

        text.write_text(normal_text, buf, i - 1)
        text.write_virtual_overlay(path_text, buf, ns, i - 1)
        text.write_virtual_right(meta_text, buf, ns, i - 1)
    end
end

return M
