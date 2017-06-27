require 'parser.lua'
JPUtil = setmetatable( {}, {
	__index = {
		-- List all global variables
		ListGlobals = function()
			print( "^5- Listing globals\n" )
			for n in pairs(_G) do print( "\n" .. n ) end
			print( "\n" )
		end,

		-- Return a list of strings delimited by div, from str
		--	credit: http://richard.warburton.it
		explode = function( div, str )
			if ( div == '' ) then
				return false
			end

			local pos, arr = 0, {}
			-- for each divider found
			for st,sp in function() return string.find( str, div, pos, true ) end do
				table.insert( arr, string.sub( str, pos, st-1 ) ) -- Attach chars left of current divider
				pos = sp+1 -- Jump past current divider
			end

			table.insert( arr, string.sub( str, pos ) ) -- Attach chars right of last divider
			return arr
		end,

		-- credit: http://lua-users.org/wiki/StringTrim
		trim6 = function( s )
			return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
		end,

		-- remove whitespace from pattern
		-- credit: http://lua-users.org/wiki/CommonFunctions
		px = function( s )
			local n = 1
			while true do
				while true do -- removes spaces
					local _, ne, np = s:find("^[^%s%%]*()%s*", n)
					n = np
					if np - 1 ~= ne then
						s = s:sub(1, np - 1) .. s:sub(ne + 1)
					else
						break
					end
				end
				local m = s:match("%%(.?)", n) -- skip magic chars
				if m == "b" then
					n = n + 4
				elseif m then
					n = n + 2
				else
					break
				end
			end
			return s
		end,


		trimWhitespace = function( str )
			return str:gsub( "%s+", " " )
		end,

		-- Return a string with the Q3 colours codes (^0 <-> ^7) stripped out
		StripColours = function( message )
			return message and string.gsub( message, "%^[0-9]", "" ) or nil
		end,

		FadeColour = function( colour, startMsec, totalMsec )
			local newcolour = colour
			local dt = GetTime() - startMsec
			local faded = true

			if dt > totalMsec then
				newcolour[4] = 0.0
			else
				dt = math.abs( dt )
				newcolour[4] = 1.0 - dt/totalMsec
				faded = false
			end
			return newcolour,faded
		end,

		--Return a table of strings split up by JA's chat message escape character.
		SplitChatMessage = function( msg )
			local splitMsg = JPUtil.explode( string.format( "%c", 0x19 ), msg )
			local len = #splitMsg

			if len == 2 then -- for regular messages, only one escape character
				local name = string.sub( splitMsg[1], 1, #splitMsg[1] ) -- strip the ^7 at the end
				local message = string.sub( splitMsg[2], 3 ) -- strip the ': ' before each message
				return name, message
			elseif len == 4 then -- for JA+ admin messages...
				local name = string.sub( splitMsg[2], 2, #splitMsg[2] ) -- strip the '(' at the start and ^7 at the end
				local message = string.sub( splitMsg[4], 4 ) -- strip the ': ^3' at the start
				return name, message
			else
				return nil, nil
			end
		end,

		deepcopy = function( obj, seen )
			if type( obj ) ~= 'table' then
				return obj
			end
			if seen and seen[obj] then
				return seen[obj]
			end
			local s = seen or {}
			local res = setmetatable( {}, getmetatable( obj ) )
			s[obj] = res
			for k, v in pairs( obj ) do
				res[JPUtil.deepcopy( k, s )] = JPUtil.deepcopy( v, s )
			end
			return res
		end,

		hexToColor = function(hex)
			if type( hex ) ~= 'number' or type( hex ) ~= 'string' then
				print("JPUtil.hexToColor: Wrong argument")
				return
			end
			local color = {
				r = 0,
				g = 0,
				b = 0,
				a = 0,
			}
			if type( hex ) == 'number' then
				color.r = (hex >> 16) & 0xFF
				color.g = (hex >> 8) & 0xFF
				color.b = hex & 0xFF
			elseif type( hex ) == 'string' then -- by jasonbradley https://gist.github.com/jasonbradley/4357406
				color.r = tonumber('0x' .. hex:sub(1,2))
				color.g = tonumber('0x' .. hex:sub(3,4))
				color.b = tonumber('0x' .. hex:sub(5,6))
			end
			return color
		end,

		colorToHex = function(color, tostr)
			if type( color ) ~= 'table' then
				print("JPUtil.colorToHex: Wrong argument")
				return
			end
			tostr = tostr or false
			local hex
			if tostr == true then --by marceloCodget https://gist.github.com/marceloCodget/3862929
				for _,v in pairs( color ) do
					while v > 0 do
						local index = math.fmod( v, 16 ) + 1
						v = math.floor( v / 16 )
						hex = string.sub( '0123456789ABCDEF', index, index ) .. hex
					end
				end
				hex = '#' .. hex
			else
				hex = ((color.r & 0xFF) << 16) + ((color.g & 0xFF) << 8) + (color.r & 0xFF)
			end
			return hex
		end
	},

	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )
