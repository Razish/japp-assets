local motd = RegisterPlugin( 'MotD', '1.3.2', '13.0.0' )

local japp_motd = CreateCvar( 'japp_motd', 'Hello!\\nThis server is running JA++\\n\\nEnjoy your stay!', CvarFlags.ARCHIVE )
local japp_motdType = CreateCvar( 'japp_motdType', '3', CvarFlags.ARCHIVE )
local japp_motdTime = CreateCvar( 'japp_motdTime', '5', CvarFlags.ARCHIVE )

function SendCommand( clientNum, countdown )
	local type = japp_motdType:GetInteger()
	local message = japp_motd:GetString()

	-- console
	if type == 1 then
		message = string.gsub( message, '\\n', '\n' )
		SendReliableCommand( clientNum, 'print "' .. message .. '\n"' )

	-- chat (sent in multiple commands for line-feeds)
	elseif type == 2 then
		local start = 0
		local slash
		while true do
			slash = string.find( message, '\\n', start )
			if slash == nil then
				SendReliableCommand( clientNum, 'chat "' .. string.sub( message, start ) .. '"\n' )
				return
			end

			SendReliableCommand( clientNum, 'chat "' .. string.sub( message, start, slash-1 ) .. '"\n' )
			slash = string.find( message, '\\n', start )
			if slash == nil then return end

			start = slash+2
		end

	-- center print
	elseif type == 3 then
		message = string.gsub( message, '\\n', '\n' )
		local i = japp_motdTime:GetInteger()
		if countdown then
			while i > 0 do ---add messages to queue :>
				local out = string.format( 'cp "%s\n TimeLeft: %i"', message, i )
				SendReliableCommand( clientNum , out )
				i = i - 1
			end
		else
			local out = string.format( 'cp "%s"', message )
			SendReliableCommand( clientNum, out )
		end
	end
end

AddClientCommand( 'ammotd', function( client, args )
	local clientNum = client.id
	SendCommand( clientNum, false  )
end )

AddClientCommand( 'amshowmotd', function( client, args )
	if not client.isAdmin then
		SendReliableCommand(client.id, string.format("You're not allowed to execute this command!\n"))
		return
	end
	if not args[1] then
		SendReliableCommand(client.id, string.format("Usage: /amshowmotd client [countdown]\n"))
		return
	end
	local clientNum = tonumber(args[1])
    local countdown = tonumber(args[2]) or false
	SendCommand( clientNum, countdown )
end )


AddListener( 'JPLUA_EVENT_CLIENTSPAWN', function( client, firstSpawn )
	local clientNum = client.id
	if firstSpawn then
		SendCommand( clientNum, true )
	end
end )
