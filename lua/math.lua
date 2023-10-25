JPMath = setmetatable({}, {
    __index = {
        -- Convert viewangles to a direction vector
        AngleVectors = function(angles, forward, right, up)
            local angle = angles.yaw * (math.pi * 2.0 / 360.0)
            local sy = math.sin(angle)
            local cy = math.cos(angle)
            angle = angles.pitch * (math.pi * 2.0 / 360.0)
            local sp = math.sin(angle)
            local cp = math.cos(angle)
            angle = angles.roll * (math.pi * 2.0 / 360.0)
            local sr = math.sin(angle)
            local cr = math.cos(angle)

            if (forward == true) then
                return Vector3(cp * cy, cp * sy, sp * -1.0)
            elseif (right == true) then
                return Vector3((-1.0 * sr * sp * cy) + (-1.0 * cr * (sy * -1.0)),
                               (-1.0 * sr * sp * sy) + (-1.0 * cr * cy), -1.0 * sr * cp)
            elseif (up == true) then
                return Vector3((cr * sp * cy + (sr * -1.0) * (sy * -1.0)), cr * sp * sy + (sr * -1.0) * cy, cr * cp)
            end
        end,

        -- Convert direction vector to viewangles
        VectorAngles = function(v)
            local forward
            local yaw
            local pitch

            if v.y == 0 and v.x == 0 then
                yaw = 0.0
                if v.z > 0.0 then
                    pitch = 90.0
                else
                    pitch = 270.0
                end
            else
                if v.x ~= nil then
                    yaw = math.atan(v.y, v.x) * 180.0 / math.pi
                elseif v.y > 0.0 then
                    yaw = 90.0
                else
                    yaw = 270.0
                end

                if yaw < 0.0 then yaw = yaw + 360.0 end

                forward = math.sqrt(v.x * v.x + v.y * v.y)
                pitch = math.atan(v.z, forward) * 180.0 / math.pi
                if pitch < 0 then pitch = pitch + 360.0 end
            end

            return Vector3(-pitch, yaw, 0.0)
        end,
    },

    __newindex = function() error('Attempt to modify read-only data!') end,

})
