local chatstyle = RegisterPlugin( "ChatStyle", "1.1" )

CreateCvar( 'cg_chatPrefix', '', CvarFlags.ARCHIVE )
CreateCvar( 'cg_chatSuffix', '', CvarFlags.ARCHIVE )

AddListener( "JPLUA_EVENT_CHATMSGSEND", function( msg, mode, target )
	if string.len( msg ) == 0 then return msg end
	local prefix = GetCvar( 'cg_chatPrefix' )
	local suffix = GetCvar( 'cg_chatSuffix' )
	return (prefix and prefix:GetString() or '') .. msg .. (suffix and suffix:GetString() or '')
end )
