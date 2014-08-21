local japluscompat = RegisterPlugin( "JA+ Compatibility", "1.1" )

AddClientCommand( 'amspectate', function( ply, args )
	if #args < 1 then
		SendReliableCommand( ply:GetID(), 'print "Syntax: \\amspectate <client>\n"' )
		return
	end

	local targ = GetPlayer( args[1] )
	if targ == nil then
		SendReliableCommand( ply:GetID(), 'print "Could not find player\n"' )
	elseif ply:IsAdmin() then
		targ:SetTeam( 's' )
	end
end )
