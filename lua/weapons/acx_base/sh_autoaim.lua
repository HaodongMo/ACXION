function SWEP:ThinkLockOn()
    local owner = self:GetOwner()

    if not ((self:GetAiming() and self.AutoAimInSights) or (not self:GetAiming() and self.AutoAimOutOfSights)) then
        self:SetLockOnEntity(nil)
        self:SetHeadLock(false)

        self:SetLockOnEntity2(nil)
        self:SetHeadLock2(false)
    else
        local lockontargets = ents.FindInCone(owner:GetShootPos(), owner:GetAimVector(), self.AutoAimRange, self.AutoAimAngle)

        local lockontarget = nil
        local angle = 90
        local headlock = false

        local lockontarget2 = nil
        local angle2 = 90
        local headlock2 = false

        local player_aim_vector = owner:GetAimVector()
        local player_aim_vector_2 = nil

        if self:GetAkimbo() then
            // Two aim vectors going slightly to the left and right of player eye angles
            local aim_angle_left = owner:EyeAngles()
            aim_angle_left:RotateAroundAxis(aim_angle_left:Up(), 10)

            local aim_angle_right = owner:EyeAngles()
            aim_angle_right:RotateAroundAxis(aim_angle_right:Up(), -10)

            player_aim_vector = aim_angle_right:Forward()
            player_aim_vector_2 = aim_angle_left:Forward()
        end

        for _, target in ipairs(lockontargets) do
            if not target:IsNPC() and not target:IsPlayer() and not target:IsNextBot() then continue end

            local try_target = nil
            if target:IsPlayer() and target:Alive() then
                try_target = target
            elseif (target:IsNPC() or target:IsNextBot()) and target:Health() > 0 then
                try_target = target
            end

            if try_target then
                // Dot product
                local target_angle = math.deg(math.acos(player_aim_vector:Dot((try_target:WorldSpaceCenter() - owner:GetShootPos()):GetNormalized())))

                if target_angle < angle then

                    local occlusion_tr = util.TraceLine({
                        start = owner:GetShootPos(),
                        endpos = try_target:WorldSpaceCenter(),
                        mask = MASK_SHOT,
                        filter = function(ent)
                            if ent == try_target then return false end
                            if ent == owner then return false end
                            if ent:IsPlayer() and ent:Team() == owner:Team() then return false end
                            return true
                        end
                    })

                    if occlusion_tr.Hit then continue end

                    lockontarget = try_target
                    angle = target_angle
                end

                if self:GetAkimbo() then
                    local target_angle2 = math.deg(math.acos(player_aim_vector_2:Dot((try_target:WorldSpaceCenter() - owner:GetShootPos()):GetNormalized())))

                    if target_angle2 < angle2 then

                        if lockontarget ~= try_target then
                            local occlusion_tr2 = util.TraceLine({
                                start = owner:GetShootPos(),
                                endpos = try_target:WorldSpaceCenter(),
                                mask = MASK_SHOT,
                                filter = function(ent)
                                    if ent == try_target then return false end
                                    if ent == owner then return false end
                                    if ent:IsPlayer() and ent:Team() == owner:Team() then return false end
                                    return true
                                end
                            })

                            if occlusion_tr2.Hit then continue end
                        end

                        lockontarget2 = try_target
                        angle2 = target_angle2
                    end
                end
            end
        end

        if self.AutoAimSeek == "both" then
            if lockontarget then
                local target_angle_head = math.deg(math.acos(player_aim_vector:Dot((lockontarget:EyePos() - owner:GetShootPos()):GetNormalized())))
                if target_angle_head < angle then
                    headlock = true
                end
            end

            if lockontarget2 then
                local target_angle_head2 = math.deg(math.acos(player_aim_vector_2:Dot((lockontarget2:EyePos() - owner:GetShootPos()):GetNormalized())))
                if target_angle_head2 < angle2 then
                    headlock2 = true
                end
            end
        elseif self.AutoAimSeek == "head" then
            if lockontarget then
                headlock = true
            end

            if lockontarget2 then
                headlock2 = true
            end
        elseif self.AutoAimSeek == "body" then
            if lockontarget then
                headlock = false
            end

            if lockontarget2 then
                headlock2 = false
            end
        end

        if lockontarget then
            self:SetLockOnEntity(lockontarget)
            self:SetHeadLock(headlock)
        else
            self:SetLockOnEntity(nil)
            self:SetHeadLock(false)
        end

        if lockontarget2 then
            self:SetLockOnEntity2(lockontarget2)
            self:SetHeadLock2(headlock2)
        else
            self:SetLockOnEntity2(nil)
            self:SetHeadLock2(false)
        end

    end

    local target_angle = self:GetTargetAngle()
    local lock_angle = self:GetLockAngle()

    // Lock angle should approach target angle
    local p = math.ApproachAngle(lock_angle.p, target_angle.p, FrameTime() * self.AutoAimSpeed)
    local y = math.ApproachAngle(lock_angle.y, target_angle.y, FrameTime() * self.AutoAimSpeed)
    local r = 0

    self:SetLockOnVector(Vector(p, y, r))

    if self:GetAkimbo() then
        local target_angle2 = self:GetTargetAngle(true)
        local lock_angle2 = self:GetLockAngle2()

        // Lock angle should approach target angle
        local p2 = math.ApproachAngle(lock_angle2.p, target_angle2.p, FrameTime() * self.AutoAimSpeed)
        local y2 = math.ApproachAngle(lock_angle2.y, target_angle2.y, FrameTime() * self.AutoAimSpeed)
        local r2 = 0

        self:SetLockOnVector2(Vector(p2, y2, r2))
    end
end

function SWEP:GetTargetAngle(left)
    local owner = self:GetOwner()

    if left then
        if IsValid(self:GetLockOnEntity2()) then
            if self:GetHeadLock2() then
                return owner:EyeAngles() - owner:GetViewPunchAngles() - (self:GetLockOnEntity2():EyePos() - owner:GetShootPos()):Angle()
            else
                return owner:EyeAngles() - owner:GetViewPunchAngles() - (self:GetLockOnEntity2():WorldSpaceCenter() - owner:GetShootPos()):Angle()
            end
        else
            return Angle(0, 0, 0)
        end
    else
        if IsValid(self:GetLockOnEntity()) then
            if self:GetHeadLock() then
                return owner:EyeAngles() - owner:GetViewPunchAngles() - (self:GetLockOnEntity():EyePos() - owner:GetShootPos()):Angle()
            else
                return owner:EyeAngles() - owner:GetViewPunchAngles() - (self:GetLockOnEntity():WorldSpaceCenter() - owner:GetShootPos()):Angle()
            end
        else
            return Angle(0, 0, 0)
        end
    end
end

function SWEP:GetLockAngle()
    local lockon = self:GetLockOnVector()
    return Angle(
        lockon.x,
        lockon.y,
        0
    )
end

function SWEP:GetLockAngle2()
    local lockon = self:GetLockOnVector2()
    return Angle(
        lockon.x,
        lockon.y,
        0
    )
end