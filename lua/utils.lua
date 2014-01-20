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
		end
	},

	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )
