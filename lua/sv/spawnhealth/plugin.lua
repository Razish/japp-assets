local sh = RegisterPlugin( 'SpawnHealth', '1.0' )

local spawnHealth = CreateCvar( 'japp_spawnHealth', "125", CvarFlags.ARCHIVE )
local spawnArmor = CreateCvar( 'japp_spawnArmor', "25", CvarFlags.ARCHIVE )

AddListener( 'JPLUA_EVENT_CLIENTSPAWN', function( ply, firstSpawn )
	ply:SetHealth( spawnHealth:GetInteger() )
	ply:SetArmor( spawnArmor:GetInteger() )
end )
