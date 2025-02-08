-- Size.lua - format sizes to human readable form

local M = {}

function M.format(bytes)
    if not bytes then
        return ""
    end

    if bytes < 1024 then
        return bytes .. "B"
    end
    local units = { "B", "KB", "MB", "GB", "TB", "PB" }
    local unit_index = 1
    local size = bytes
    while size >= 1024 and unit_index < #units do
        size = size / 1024
        unit_index = unit_index + 1
    end
    return string.format("%.2f%s", size, units[unit_index])
end

return M
