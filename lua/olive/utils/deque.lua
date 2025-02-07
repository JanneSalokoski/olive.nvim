-- deque.lua - implementation of a deque

-- the structure is mostly copied from: https://www.lua.org/pil/11.4.html
-- but slightly modified for our usecase.

local Deque = {}

function Deque.new()
    return {
        first = 0,
        last = -1,
    }
end

function Deque.pushleft(list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function Deque.pushright(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function Deque.popleft(list)
    local first = list.first
    if first > list.last then
        return nil -- return nil if list is empty
    end

    local value = list[first]

    list[first] = nil -- allow gc
    list.first = first + 1

    return value
end

function Deque.popright(list)
    local last = list.last
    if list.first > last then
        return nil -- return nil if list is empty
    end

    local value = list[last]

    list[last] = nil -- allow gc
    list.last = last - 1

    return value
end

return Deque
