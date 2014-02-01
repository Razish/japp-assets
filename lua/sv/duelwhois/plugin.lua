local dwi = RegisterPlugin( 'DuelWhois', '1.0' )

AddClientCommand( 'duelwhois', function( ply, args )
	local partners = {}
	local p2 = nil
	local partner = nil
	local count = 0
	local msg = ''

	for i=0,31 do
		p2 = GetPlayer( i )
		partner = p2 and p2:GetDuelingPartner() or nil

		if partner ~= nil and partners[partner:GetID()] == nil then
			count = count+1
			msg = msg .. string.format( '^7(^5%2i^7) ' .. p2:GetName() .. ' ^7is dueling with '
				.. GetPlayer( partner:GetID() ):GetName() .. '\n', count );
			partners[i] = partner:GetID()
		end
	end

	if #msg > 0 then
		SendReliableCommand( ply:GetID(), 'print "' .. msg .. '\n"' )
	end
end )
