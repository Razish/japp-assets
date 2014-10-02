local automsg = RegisterPlugin( 'AutoMsg', '1.1' )

local cvars = {
	['japp_autoMsgText']	= CreateCvar( 'japp_autoMsgText', "^7Have a nice day :-)\nRemember to have fun!", CvarFlags.ARCHIVE ),
	['japp_autoMsgType']	= CreateCvar( 'japp_autoMsgType', "2", CvarFlags.ARCHIVE ),
	['japp_autoMsgDelay']	= CreateCvar( 'japp_autoMsgDelay', "900", CvarFlags.ARCHIVE ),
}

local msgTime = 0

function SendMessage( clientNum )
	local type = cvars['japp_autoMsgType']:GetInteger()
	local message = cvars["japp_autoMsgText"]:GetString()

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
		SendReliableCommand( clientNum, 'cp "' .. message .. '"' )
	end
end

AddClientCommand( 'amautomsg', function( client, args )
	SendMessage( client:GetID() )
end )

AddListener( 'JPLUA_EVENT_CLIENTSPAWN', function( client, firstSpawn )
	if firstSpawn then
		SendCommand( client:GetID() )
	end
end )

AddListener( 'JPLUA_EVENT_RUNFRAME', function()
	local msgDelay = cvars['japp_autoMsgDelay']:GetInteger() * 1000
	if msgTime < GetTime() - msgDelay then
		print( 'derp' )
		for _,ply in ipairs(GetPlayers()) do
			SendMessage( ply:GetID() )
		end
		msgTime = GetTime()
	end
end )
