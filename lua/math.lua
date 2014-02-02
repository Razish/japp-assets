JPMath = setmetatable( {}, {
	__index = {
		-- Create a vector3 for use with the game
		Vector3 = function( x, y, z )
			return { ['x'] = x, ['y'] = y, ['z'] = z }
		end,

		-- Create an angle3 for use with the game
		Angle3 = function( pitch, yaw, roll )
			return { ['pitch'] = pitch, ['yaw'] = yaw, ['roll'] = roll }
		end,

		-- Convert viewangles to a direction vector
		AngleVectors = function( angles, forward, right, up )
			local angle = angles.yaw * (math.pi*2.0 / 360.0)
			local sy = math.sin( angle )
			local cy = math.cos( angle )
			angle = angles.pitch * (math.pi*2.0 / 360.0)
			local sp = math.sin( angle )
			local cp = math.cos( angle )
			angle = angles.roll * (math.pi*2.0 / 360.0)
			local sr = math.sin( angle )
			local cr = math.cos( angle )

			if ( forward == true ) then
				return { x = (cp*cy), y = (cp*sy), z = (sp*-1.0) }
			elseif ( right == true ) then
				return { x = (-1.0*sr*sp*cy)+(-1.0*cr*(sy*-1.0)), y = (-1.0*sr*sp*sy)+(-1.0*cr*cy), z = (-1.0*sr*cp) }
			elseif ( up == true ) then
				return { x = (cr*sp*cy+(sr*-1.0)*(sy*-1.0)), y = (cr*sp*sy+(sr*-1.0)*cy), z = (cr*cp) }
			end
		end,

		-- Convert direction vector to viewangles
		VectorAngles = function( vector )
			local forward
			local yaw
			local pitch

			if vector.y == 0 and vector.x == 0 then
				yaw = 0.0
				if vector.z > 0.0 then
					pitch = 90.0
				else
					pitch = 270.0
				end
			else
				if vector.x ~= nil then
					yaw = math.atan2( vector.y, vector.x ) * 180.0 / math.pi
				elseif vector.y > 0.0 then
					yaw = 90.0
				else
					yaw = 270.0
				end

				if yaw < 0.0 then
					yaw = yaw + 360.0
				end

				forward = math.sqrt( vector.x*vector.x + vector.y*vector.y )
				pitch = math.atan2( vector.z, forward ) * 180.0 / math.pi
				if pitch < 0 then
					pitch = pitch + 360.0
				end
			end

			return { pitch = -pitch, yaw = yaw, roll = 0.0 }
		end,

		-- Matches VectorMA from JA
		Vector3MA = function( v, s, b )
			return { x = v.x+b.x*s, y = v.y+b.y*s, z = v.z+b.z*s }
		end,

		-- Scale a 3D vector
		Vector3Scale = function( v, s )
			return JPMath.Vector3( v.x*s, v.y*s, v.z*s )
		end,

		-- Normalises a 3D vector
		Vector3Normalise = function( v )
			local length = JPMath.DotProduct( v )
			if ( length ) then
				return JPMath.Vector3Scale( v, 1.0/math.sqrt( length ) )
			end
			return v
		end,

		DotProduct = function( v1, v2 )
			if v2 == nil then
				return v1.x*v1.x + v1.y*v1.y + v1.z*v1.z
			else
				return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
			end
		end,
	},

	__newindex = function() error( "Attempt to modify read-only data!" ) end
} )
