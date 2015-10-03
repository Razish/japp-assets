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

		-- Return a string with the Q3 colours codes (^0 <-> ^7) stripped out
		StripColours = function( message )
			return string.gsub( message, "%^[0-9]", "" )
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
				local name = string.sub( splitMsg[1], 1, string.len(splitMsg[1])-2 ) -- strip the ^7 at the end
				local message = string.sub( splitMsg[2], 3 ) -- strip the ': ' before each message
				return name, message
			elseif len == 4 then -- for JA+ admin messages...
				local name = string.sub( splitMsg[2], 2, string.len(splitMsg[2])-2 ) -- strip the '(' at the start and ^7 at the end
				local message = string.sub( splitMsg[4], 4 ) -- strip the ': ^3' at the start
				return name, message
			else
				return nil, nil
			end
		end
	},

	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )
