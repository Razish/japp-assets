local chatstyle = RegisterPlugin( 'ChatStyle', '1.2.0', '13.0.0' )

local cvars = {
	['cg_chatPrefix']	= CreateCvar( 'cg_chatPrefix', '', CvarFlags.ARCHIVE ),
	['cg_chatSuffix']	= CreateCvar( 'cg_chatSuffix', '', CvarFlags.ARCHIVE ),
	['cg_chatStyle']	= CreateCvar( 'cg_chatStyle', '1', CvarFlags.ARCHIVE ),
}

AddListener( 'JPLUA_EVENT_CHATMSGSEND', function( msg, mode, target )
	local enabled = cvars['cg_chatStyle']:GetInteger()
	if string.len( msg ) == 0 or bit32.band( enabled, bit32.lshift( 1, mode ) ) ~= enabled then
		return msg
	end
	return cvars['cg_chatPrefix']:GetString() .. msg .. cvars['cg_chatSuffix']:GetString()
end )
