local strafehud = RegisterPlugin( "Strafe HUD", "1.0", 3 )

local cvars = {
	cg_strafeHUD			= CreateCvar( "cg_strafeHUD", 23, CvarFlags.ARCHIVE ),
--	cg_accelerometerPos		= CreateCvar( "cg_accelerometerPos", "320 360", CvarFlags.ARCHIVE ),
--	cg_accelerometerSize	= CreateCvar( "cg_accelerometerSize", "128 20", CvarFlags.ARCHIVE ),
}
--[[
	1	Current UPS
	2	Highest UPS in last 2000ms
	4	View angles
	8	Position
	16	REMOVED -- Accelerometer
]]

local bestSpeed = { lastTime = GetTime(), speed = 0 }
local lastVelocity = { x=0, y=0, z=0 }
local lastSpeed = 0.0
--local accelSamples = {}
AddListener( "JPLUA_EVENT_HUD", function()
	local strafeHUD = cvars["cg_strafeHUD"]:GetInteger()
	local fontIndex = Fonts.JAPPLARGE
	local fontScale = 0.5
	local y = 300
	local lineHeight = 20

	-- if it's been too long since we sailed through the air, reset it to 0
	if bestSpeed.lastTime < GetTime() - 2000 then
		bestSpeed.speed = 0
	end

	local self = GetPlayer(nil)
	local velocity = self.velocity
	local angles = self.angles
	local speed = math.sqrt( velocity.x*velocity.x + velocity.y*velocity.y )
	local position = self.position

	if ( speed > bestSpeed.speed ) then
		bestSpeed.speed = speed
		bestSpeed.lastTime = GetTime()
	end

	-- Accelerometer start
	--[[
	local currentVelocity = velocity
	currentVelocity.z = 0.0
	local accel = speed-lastSpeed
	local maxSpeed = 250 --TODO: force speed, g_speed
	local maxAccel = (maxSpeed/GetFPS())

	--store for next frame
	lastVelocity = currentVelocity
	lastSpeed = speed

	-- add a sample to the end, and remove the first sample to avoid an obscenely large table
	table.insert( accelSamples, accel )
	if ( #accelSamples > 16 ) then
		table.remove( accelSamples, 1 )
	end

	local avgAccel = 0.0
	local len = math.min(16,#accelSamples)
	for i = 1,len do
		avgAccel = avgAccel + accelSamples[i]
	end

	avgAccel = avgAccel / len
	--]]
	-- Accelerometer end

	-- Current UPS
	if bit32.band( strafeHUD, 1 ) ~= 0 then
		local msg = string.format( "%06.2f", speed)
		DrawText( 320-Font_StringLengthPixels( msg, fontScale, fontIndex )/2.0, y, msg, { 0.567, 0.685, 1.0, 1.0 }, fontScale, TextStyle.SHADOWED, fontIndex )
		y = y + lineHeight
	end

	-- Highest UPS in last 2000ms
	if bit32.band( strafeHUD, 2 ) ~= 0 then
		local msg = string.format( "%06.2f", bestSpeed.speed)
		DrawText( 320-Font_StringLengthPixels( msg, fontScale, fontIndex )/2.0, y, msg, { 0.42525, 0.51375, 0.75, 1.0 }, fontScale, TextStyle.SHADOWED, fontIndex )
		y = y + lineHeight
	end

	-- Viewangles
	if bit32.band( strafeHUD, 4 ) ~= 0 then
		local msg = string.format( "%06.3f / %06.3f", angles.yaw, -angles.pitch )
		DrawText( 320-Font_StringLengthPixels( msg, fontScale, fontIndex )/2.0, y, msg, { 1.0, 0.5, 0.0, 1.0 }, fontScale, TextStyle.SHADOWED, fontIndex )
		y = y + lineHeight
	end

	-- Position
	if bit32.band( strafeHUD, 8 ) ~= 0 then
		local msg = string.format( "%06.3f", position.x )
		DrawText( 320-Font_StringLengthPixels( msg, fontScale, fontIndex )/2.0, y, msg, { 0.6, 0.6, 0.6, 1.0 }, fontScale, TextStyle.SHADOWED, fontIndex )
		y = y + lineHeight

		msg = string.format( "%06.3f", position.y )
		DrawText( 320-Font_StringLengthPixels( msg, fontScale, fontIndex )/2.0, y, msg, { 0.6, 0.6, 0.6, 1.0 }, fontScale, TextStyle.SHADOWED, fontIndex )
		y = y + lineHeight

		msg = string.format( "%06.3f", position.z )
		DrawText( 320-Font_StringLengthPixels( msg, fontScale, fontIndex )/2.0, y, msg, { 0.6, 0.6, 0.6, 1.0 }, fontScale, TextStyle.SHADOWED, fontIndex )
		y = y + lineHeight
	end

	-- Accelerometer
	--[[
	if bit32.band( strafeHUD, 16 ) ~= 0 then
		local pos = { x=320, y=360 }
		local size = { width=128, height=20 }

		local tmp = JPUtil.explode( ' ', cvars["cg_accelerometerPos"]:GetString() )
		if ( #tmp == 2 ) then
			pos.x = tmp[1]
			pos.y = tmp[2]
		end
		tmp = JPUtil.explode( ' ', cvars["cg_accelerometerSize"]:GetString() )
		if ( #tmp == 2 ) then
			size.width = tmp[1]
			size.height = tmp[2]
		end

		local percent = (avgAccel/maxAccel) * size.width
		if percent ~= 0 then
			DrawRect( (pos.x+1), pos.y+1, size.width-(size.width-percent)-2, size.height-2, { 1.0, 0.0, 0.0, 1.0 } );
		end
	end
	--]]

	return 0
end )
