local sh = RegisterPlugin( 'SpawnHealth', '1.0' )

local spawnHealth = CreateCvar( 'japp_spawnHealth', "100", CvarFlags.ARCHIVE )
local spawnArmor = CreateCvar( 'japp_spawnArmor', "0", CvarFlags.ARCHIVE )

AddListener( 'JPLUA_EVENT_CLIENTSPAWN', function( ply, firstSpawn )
	-- check if team != spectator? does that happen?
	if ply.team == Team.Spectator then
		return
	end
	ply.health = spawnHealth:GetInteger()
	ply.armor = spawnArmor:GetInteger()
end )
