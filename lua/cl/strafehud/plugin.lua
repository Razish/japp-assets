local strafehud = RegisterPlugin( 'Strafe HUD', '1.3.1', '13.1.0' )

strafehud.text = TextBox()
	strafehud.text.scale = 0.66666
	strafehud.text.font = RegisterFont( Font.SMALL )
	strafehud.text.colour = { 1.0, 0.0, 0.0, 1.0 }
	strafehud.text.style = TextStyle.Shadowed
	strafehud.text.centered = true

local cvars = {
	cg_strafeHUD			= CreateCvar( 'cg_strafeHUD', 3, CvarFlags.ARCHIVE ),
}
--[[
	1	Current UPS
	2	Highest UPS in last 2000ms
	4	Highest UPS on ground in last 2000ms
	8	Jump timer
	16	View angles
	32	Position
]]

local bestSpeed = { lastTime = GetTime(), speed = 0 }
local groundSpeed = { lastTime = GetTime(), speed = 0 }
local lastVelocity = { x=0, y=0, z=0 }
local lastSpeed = 0.0
local wasInAir = false
local trackJump = false
local jumpStartTime = 0
local jumpEndTime = 0
local jumpLow = 0.0
local jumpHigh = 0.0

AddListener( 'JPLUA_EVENT_HUD', function( events )
	local strafeHUD = cvars['cg_strafeHUD']:GetInteger()
	if strafeHUD == 0 then
		return events
	end

	local x = screenWidth / 1.5
	local y = 400
	local currTime = GetTime()

	-- if it's been too long since we sailed through the air, reset it to 0
	if bestSpeed.lastTime < currTime - 2000 then
		bestSpeed.speed = 0
	end
	
	if groundSpeed.lastTime < currTime - 2000 then
		groundSpeed.speed = 0
	end

	local self = GetPlayer(nil)
	local velocity = self.velocity
	local angles = self.angles
	local speed = math.sqrt( velocity.x*velocity.x + velocity.y*velocity.y )
	local position = self.position

	if speed > bestSpeed.speed then
		bestSpeed.speed = speed
		bestSpeed.lastTime = currTime
	end

	if self.isInAir == false and speed > groundSpeed.speed then
		groundSpeed.speed = speed
		groundSpeed.lastTime = currTime
	end
	
	-- jump measure
	if self.isInAir and wasInAir == false then
		-- start jump
		trackJump = true
		jumpStartTime = currTime
		jumpLow = position.z
		jumpHigh = jumpLow
	end
	if self.isInAir == false then
		-- end jump
		trackJump = false
		jumpLow = 0.0
		jumpHigh = 0.0
	end
	if trackJump then
		-- update height + duration each frame
		if position.z > jumpHigh then
			jumpHigh = position.z
		end
		jumpEndTime = currTime
	end
	wasInAir = self.isInAir

	-- Current UPS
	if bit32.band( strafeHUD, 1 ) ~= 0 then
		strafehud.text.text = string.format( '%06.2f', speed )
		strafehud.text.colour = { 0.567, 0.685, 1.0, 1.0 }
		strafehud.text:Draw( x, y )
		y = y + strafehud.text.height
	end

	-- Highest UPS in last 2000ms
	if bit32.band( strafeHUD, 2 ) ~= 0 then
		strafehud.text.text = string.format( '%06.2f', bestSpeed.speed )
		strafehud.text.colour = { 0.42525, 0.51375, 0.75, 1.0 }
		strafehud.text:Draw( x, y )
		y = y + strafehud.text.height
	end

	-- Highest UPS on ground in last 2000ms
	if bit32.band( strafeHUD, 4 ) ~= 0 then
		strafehud.text.text = string.format( '%06.2f', groundSpeed.speed )
		strafehud.text.colour = { 0.42525, 0.51375, 0.75, 1.0 }
		strafehud.text:Draw( x, y )
		y = y + strafehud.text.height
	end

	-- jump measure
	if bit32.band( strafeHUD, 8 ) ~= 0 then
		strafehud.text.text = string.format( '%06.2f, %i', jumpHigh - jumpLow, jumpEndTime - jumpStartTime )
		strafehud.text.colour = { 0.75, 0.51375, 0.75, 1.0 }
		strafehud.text:Draw( x, y )
		y = y + strafehud.text.height
	end

	-- Viewangles
	if bit32.band( strafeHUD, 16 ) ~= 0 then
		strafehud.text.text = string.format( '%06.3f / %06.3f', angles.yaw, -angles.pitch )
		strafehud.text.colour = { 1.0, 0.5, 0.0, 1.0 }
		strafehud.text:Draw( x, y )
		y = y + strafehud.text.height
	end

	-- Position
	if bit32.band( strafeHUD, 32 ) ~= 0 then
		strafehud.text.text = string.format( '%06.3f', position.x )
		strafehud.text.colour = { 0.6, 0.6, 0.6, 1.0 }
		strafehud.text:Draw( x, y )
		y = y + strafehud.text.height

		strafehud.text.text = string.format( '%06.3f', position.y )
		strafehud.text.colour = { 0.6, 0.6, 0.6, 1.0 }
		strafehud.text:Draw( x, y )
		y = y + strafehud.text.height

		strafehud.text.text = string.format( '%06.3f', position.z )
		strafehud.text.colour = { 0.6, 0.6, 0.6, 1.0 }
		strafehud.text:Draw( x, y )
		y = y + strafehud.text.height
	end

	return events
end )
