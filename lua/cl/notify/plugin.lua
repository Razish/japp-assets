local notify = RegisterPlugin( 'Notifications', '1.0.0', '13.6.0' )

local cvars = {
	['cg_notifyTriggers']	= CreateCvar( 'cg_notifyTriggers', "", CvarFlags.ARCHIVE ),
	['cg_notifyConnect']	= CreateCvar( 'cg_notifyConnect', "1", CvarFlags.ARCHIVE ),
}

--[[
AddConsoleCommand( 'notify', function( cmd, args )
	-- TODO: test function
end )

AddListener( 'JPLUA_EVENT_CHATMSGSEND', function( msg )
	if #msg == 0 then
		return nil
	end
	--TODO: warn for msg overflow
	return msg
end )
--]]

AddListener( 'JPLUA_EVENT_CLIENTCONNECT', function( player )
	if cvars['cg_notifyConnect']:GetBoolean() then
		--TODO: check if we were the only other player in the server, now we have friends :3
		SendNotification( 'connect', '* ' .. JPUtil.StripColours( player.name ) .. ' connected', 3000, 'call-start' )
	end
end )

AddListener( 'JPLUA_EVENT_CHATMSGRECV', function( msg )
	local sender, text = JPUtil.SplitChatMessage( msg )
	if sender == nil or text == nil then
		return msg
	end
	local ply = GetPlayer( sender )
	if ply ~= nil then
		local ourName = JPUtil.StripColours( GetPlayer(nil).name )
		if string.find( text:lower(), ourName:lower(), 1, true ) then
			SendNotification( 'mentioned by ' .. JPUtil.StripColours( ply.name ), JPUtil.StripColours( text ), 5000, 'appointment-new' )
		else
			local toks = JPUtil.explode( ' ', text )
			local triggers = JPUtil.explode( ' ', cvars['cg_notifyTriggers']:GetString() )
			for k1,tok in next,toks do
				for k2,trigger in next,triggers do
					if tok == trigger then
						SendNotification( '#TRIGGERED', JPUtil.StripColours( text ):gsub( trigger, '#' .. trigger .. '#' ), 5000, 'emblem-important' )
						break
					end
				end
			end
		end
	end
	return msg
end )
