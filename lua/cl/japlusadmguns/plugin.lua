local japlusadmguns = RegisterPlugin( 'JA+ Admin Guns', '1.0.0', '13.0.0' )

local function GetTarget()
	local self = GetPlayer(nil)
	local pos = self.position
	pos.z = pos.z + 36.0 -- move to eye-position
	local angles = JPMath.AngleVectors( self.angles, true, false, false )
	local endPos = pos:MA( 16384.0, angles )
	local mask = 1184515 -- MASK_OPAQUE|CONTENTS_BODY|CONTENTS_ITEM|CONTENTS_CORPSE
	local tr = RayTrace( pos, 1.0, endPos, self.id, mask )
	if tr.entityNum >= 0 and tr.entityNum < 32 then
		return tr.entityNum, GetPlayer( tr.entityNum )
	else
		return nil
	end
end

AddConsoleCommand( 'gunslap', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amslap %i', target ) ) end
end )
AddConsoleCommand( 'gunsilence', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amsilence %i', target ) ) end
end )
AddConsoleCommand( 'gununsilence', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amunsilence %i', target ) ) end
end )
AddConsoleCommand( 'gunprotect', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amprotect %i', target ) ) end
end )
AddConsoleCommand( 'gunsleep', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amsleep %i', target ) ) end
end )
AddConsoleCommand( 'gunwake', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amwake %i', target ) ) end
end )
AddConsoleCommand( 'gunmindtrick', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'ammindtrick %i', target ) ) end
end )
AddConsoleCommand( 'gununmindtrick', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'ammindtrick %i', target ) ) end
end )
AddConsoleCommand( 'gunkick', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amkick %i', target ) ) end
end )
AddConsoleCommand( 'gunban', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amban %i', target ) ) end
end )
AddConsoleCommand( 'gunghost', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amghost %i', target ) ) end
end )
AddConsoleCommand( 'gunpunish', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'ampunish %i', target ) ) end
end )
local GunEmpower = function()
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amempower %i', target ) ) end
end
AddConsoleCommand( 'gunemp', GunEmpower )
AddConsoleCommand( 'gunempower', GunEmpower )
AddConsoleCommand( 'gunmerc', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'ammerc %i', target ) ) end
end )
AddConsoleCommand( 'gunannounce', function( args )
	message = table.concat( args, ' ' )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'ampsay %i %s', target, message ) ) end
end )
AddConsoleCommand( 'gunsay', function( args )
	_, target = GetTarget()
	if target ~= nil then SendChatText( string.format( '^7Client ID of \"%s^7\" is: ^5%02i', target.GetName(), target.GetID() ) ) end
end )
AddConsoleCommand( 'gunslay', function( args )
	target = GetTarget()
	if target ~= nil then SendServerCommand( string.format( 'amslay %i', target ) ) end
end )

AddConsoleCommand( 'clguntele', function( args )
	local self = GetPlayer(nil)
	local pos = self:GetPosition()
	pos.z = pos.z + 36.0 -- move to eye-position
	local angles = JPMath.AngleVectors( self:GetAngles(), true, false, false )
	local endPos = JPMath.Vector3MA( pos, 16384.0, angles )
	local mask = 1184515 -- MASK_OPAQUE|CONTENTS_BODY|CONTENTS_ITEM|CONTENTS_CORPSE
	local tr = RayTrace( pos, 1.0, endPos, self:GetID(), mask )
	local tr2 = RayTrace( tr.endpos, 1.0, JPMath.Vector3MA( tr.endpos, 24.0, tr.plane.normal ), self:GetID(), mask )
	if tr2.allsolid or tr2.startsolid then
		print( 'Refusing to teleport: would end up inside a wall\n' )
	else
		SendServerCommand( string.format( 'amtele %i %.2f %.2f %.2f %i', self:GetID(), tr2.endpos.x, tr2.endpos.y, tr2.endpos.z, self:GetAngles().y ) )
	end
end )
