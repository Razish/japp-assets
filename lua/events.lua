EventPriority = setmetatable({}, {
    __index = {LOW = 0, NORMAL = 1, HIGH = 2},
    __newindex = function() error('Attempt to modify read-only data!') end,
})
