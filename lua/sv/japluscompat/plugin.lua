local japluscompat = RegisterPlugin( "JA+ Compatibility", "1.0" )

AddClientCommand( 'amspectate', function( ply, args )
	if #args < 1 then
		SendReliableCommand( ply:GetID, 'print "Syntax: \\amspectate <client>\n"' )
		return
	end

	local targ = GetPlayer( args[1] )
	if targ == nil then
		SendReliableCommand( ply:GetID, 'print "Could not find player\n"' )
	else
		targ:SetTeam( 's' )
	end
end )
