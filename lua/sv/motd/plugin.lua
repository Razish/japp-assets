local motd = RegisterPlugin( 'MotD', '1.3.1', '13.0.0' )

local cvars = {
	['japp_motd']		= CreateCvar( 'japp_motd', 'Hello!\\nThis server is running JA++\\n\\nEnjoy your stay!', CvarFlags.ARCHIVE ),
	['japp_motdType']	= CreateCvar( 'japp_motdType', '3', CvarFlags.ARCHIVE ),
	['japp_motdTime']	= CreateCvar( 'japp_motdTime', '5', CvarFlags.ARCHIVE ),
}

local joinTimes = {}
local firstMsgTime = {}
local msgTimes = {}

function SendCommand( clientNum, levelTime )
	local type = cvars['japp_motdType']:GetInteger()
	local message = cvars['japp_motd']:GetString()

	-- console
	if type == 1 then
		message = string.gsub( message, '\\n', '\n' )
		SendReliableCommand( clientNum, 'print "' .. message .. '\n"' )

	-- chat (sent in multiple commands for line-feeds)
	elseif type == 2 then
		local start = 0
		local slash = nil
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
		local out = 'cp "' .. message .. '\n'
		if firstMsgTime[clientNum] ~= nil then
			out = out .. 'Time left: ' .. math.ceil( (firstMsgTime[clientNum]-levelTime + (cvars['japp_motdTime']:GetInteger()*1000))/1000 ) .. '"'
		else
			out = out .. '"'
		end
		SendReliableCommand( clientNum, out )
	end
end

AddClientCommand( 'ammotd', function( client, args )
	local clientNum = client.id
	local levelTime = GetTime()
	joinTimes[clientNum] = levelTime
	msgTimes[clientNum] = levelTime
	firstMsgTime[clientNum] = levelTime
	SendCommand( clientNum, levelTime )
end )

AddClientCommand( 'amshowmotd', function( client, args )
	if not client.isAdmin then
		SendReliableCommand(client.id, string.format("You're not allowed to execute this command!\n"))
		return
	end
	if not args[1] then
		SendReliableCommand(client.id, string.format("Usage: /amshowmotd client\n"))
		return
	end
	local clientNum = tonumber(args[1])
	local levelTime = GetTime()
	joinTimes[clientNum] = levelTime
	msgTimes[clientNum] = levelTime
	firstMsgTime[clientNum] = levelTime
	SendCommand( clientNum, levelTime )
end )


AddListener( 'JPLUA_EVENT_CLIENTSPAWN', function( client, firstSpawn )
	local clientNum = client.id
	if firstSpawn then
		if cvars['japp_motdType']:GetInteger() == 3 then
			local levelTime = GetTime()
			joinTimes[clientNum] = levelTime
			msgTimes[clientNum] = levelTime
			firstMsgTime[clientNum] = nil
		else
			SendCommand( clientNum, nil )
		end
	end
end )

AddListener( 'JPLUA_EVENT_RUNFRAME', function()
	if cvars['japp_motdType']:GetInteger() ~= 3 then
		return
	end

	local msg = nil
	local levelTime = GetTime()
	local msgTime = cvars['japp_motdTime']:GetInteger() * 1000
	for _,ply in ipairs(GetPlayers()) do
		if ply.isBot then
			-- ignore
		else
			local i = ply.id
			if joinTimes[i] ~= nil and joinTimes[i] > levelTime-msgTime then
				if msgTimes[i] ~= nil and msgTimes[i] < levelTime-1000 then
					if firstMsgTime[i] == nil then
						firstMsgTime[i] = levelTime
					end
					msgTimes[i] = levelTime
					SendCommand( i, levelTime )
				end
			elseif joinTimes[i] ~= nil and joinTimes[i] > levelTime-msgTime-1000 then
				if msgTimes[i] ~= nil and msgTimes[i] < levelTime-1000 then
					if firstMsgTime[i] == nil then
						firstMsgTime[i] = levelTime
					end
					msgTimes[i] = levelTime
					SendReliableCommand( i, 'cp ""' )
				end
			end
		end
	end
end )
