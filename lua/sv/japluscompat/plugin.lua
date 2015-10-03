local japluscompat = RegisterPlugin( 'JA+ Compatibility', '1.1.1', '13.0.0' )

AddClientCommand( 'amspectate', function( ply, args )
	if #args < 1 then
		SendReliableCommand( ply.id, 'print "Syntax: \\amspectate <client>\n"' )
		return
	end

	local targ = GetPlayer( args[1] )
	if targ == nil then
		SendReliableCommand( ply.id, 'print "Could not find player\n"' )
	elseif ply.isAdmin then
		targ:SetTeam( 's' )
	end
end )
