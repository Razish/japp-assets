local mscale = RegisterPlugin( 'ModelScale', '1.0.0', '13.3.7' )
mscale.list = {}

local cvars = {
	['japp_modelScaleCmd'] = CreateCvar( 'japp_modelScaleCmd', '0', CvarFlags.ARCHIVE ),
	['japp_modelScaleRange'] = CreateCvar( 'japp_modelScaleRange', '80 120', CvarFlags.ARCHIVE )
}

local function ParseToken( str, idx )
	return JPUtil.explode( ' ', str )[idx]
end

local function LoadCFG()
	local file = OpenFile( 'modelscale.cfg', FSMode.Read )
	local bah = file:Read( file:Length() )
	local bah2 = COM_Compress( bah )
	local bah3 = JPUtil.explode( '\n', bah2 )
	--[[
	for i,v in next, bah3 do
		print( v )
	end
	--]]
end
LoadCFG()
AddListener( 'JPLUA_EVENT_CLIENTDISCONNECT', function( ply )
	mscale.list[ply.id] = nil
end )

AddListener( 'JPLUA_EVENT_CLIENTSPAWN', function( ply, firstSpawn )
	if mscale.list[ply.id] then
		print( 'scaling by ' .. mscale.list[ply.id] )
		ply.entity:Scale( mscale.list[ply.id] )
	end
end )

AddClientCommand( 'modelscale', function( ply, args )
	if not cvars['japp_modelScaleCmd']:GetBoolean() then
		return
	end

	if #args == 1 then
		local scale = tonumber(args[1])
		if scale then
			-- make sure it's in valid range
			local str = cvars['japp_modelScaleRange']:GetString()
			local range = { min = tonumber(ParseToken( str, 1 )), max = tonumber(ParseToken( str, 2 )) }
			scale = math.min( scale, range.max )
			scale = math.max( range.min, scale )
			ply.entity:Scale( scale )
			mscale.list[ply.id] = scale
			ply:ConsolePrint( ChatColour.Cyan .. 'setting model scale to ' .. ChatColour.Yellow .. scale .. '\n' )
		end
	else
		ply:ConsolePrint(
			ChatColour.Cyan .. 'your model scale is: ' .. ChatColour.Yellow
			.. (mscale.list[ply.id] and tostring(mscale.list[ply.id]) or '100') .. '\n'
		)
	end
end )
