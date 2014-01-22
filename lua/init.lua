JPLua = setmetatable( {}, {
	__index = { version = 5 },
	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )

require "utils.lua"
require "math.lua"
require "events.lua"
require "constants.lua"

print( "Version: " .. JPLua.version .. " on " .. _VERSION .. "\n" )
