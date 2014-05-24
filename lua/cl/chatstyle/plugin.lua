local chatstyles = RegisterPlugin( "ChatStyles", "1.0" )

AddListener( "JPLUA_EVENT_CHATMSGSEND", function( msg, mode, target )
	if string.len( msg ) then return msg end
	local prefix = GetCvar('japp_chatPrefix')
	local suffix = GetCvar('japp_chatSuffix')
	return (prefix and prefix:GetString() or '') .. msg .. (suffix and suffix:GetString() or '')
end )
