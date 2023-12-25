local rising_edge_firemodes = {
    ["semi"] = true,
    ["binary"] = true,
    ["pump"] = true,
    ["bolt"] = true,
    ["burst_3"] = true
}

local falling_edge_firemodes = {
    ["semi_falling"] = true,
    ["binary"] = true,
}

local auto_firemodes = {
    ["auto"] = true
}

function SWEP:Think()
    if not IsValid(self:GetOwner()) then return false end

    // self:SetAiming(self:ShouldAim())
    if self:ShouldAim() and not self:GetAiming() then
        self:ToggleAim(true)
    elseif not self:ShouldAim() and self:GetAiming() then
        self:ToggleAim(false)
    end

    self:ThinkLockOn()

    if CLIENT and self:GetOwner() == LocalPlayer() then
        if self:GetShouldRaiseRight() then
            self.LowerAmountRight = math.Approach(self.LowerAmountRight, 0, FrameTime() / self.HolsterTime)
        else
            self.LowerAmountRight = math.Approach(self.LowerAmountRight, 1, FrameTime() / self.HolsterTime)
        end

        if self:GetShouldRaiseLeft() then
            self.LowerAmountLeft = math.Approach(self.LowerAmountLeft, 0, FrameTime() / self.HolsterTime)
        else
            self.LowerAmountLeft = math.Approach(self.LowerAmountLeft, 1, FrameTime() / self.HolsterTime)
        end

        if self:GetAiming() then
            self.SightAmount = math.Approach(self.SightAmount, 1, FrameTime() / 0.25)
        else
            self.SightAmount = math.Approach(self.SightAmount, 0, FrameTime() / 0.25)
        end

        self.InterpolatedLockAngle = LerpAngle(0.99 * FrameTime(), self.InterpolatedLockAngle, self:GetLockAngle())
        self.InterpolatedLockAngle2 = LerpAngle(0.99 * FrameTime(), self.InterpolatedLockAngle2, self:GetLockAngle2())
    end

    -- Predicted block
    if game.SinglePlayer() and CLIENT then return end

    if self:GetBurstCount() > 0 and string.sub(self.Firemode, 1, 6) == "burst_" then
        local burst_length = tonumber(string.sub(self.Firemode, 7, 7))

        if self:GetBurstCount() >= burst_length then
            self:SetBurstCount(0)
            self:SetShotQueued(false)
            self:SetWaitTime(CurTime() + self.BurstDelay)
        else
            self:SetShotQueued(true)
        end
    end

    if self:GetAkimbo() then
        if self:GetBurst2Count() > 0 and string.sub(self.Firemode, 1, 6) == "burst_" then
            local burst_length = tonumber(string.sub(self.Firemode, 7, 7))

            if self:GetBurst2Count() >= burst_length then
                self:SetBurst2Count(0)
                self:SetShot2Queued(false)
                self:SetWait2Time(CurTime() + self.BurstDelay)
            else
                self:SetShot2Queued(true)
            end
        end

        if not self:GetReloading() then
            if self:GetNeedCycle() then
                if self:GetOwner():KeyDown(IN_WEAPON2) then
                    self:SetNeedCycle(false)
                    self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                end
            else
                if self:Clip1() <= 0 then
                    if self:GetOwner():KeyPressed(IN_ATTACK2) then
                        self:SetShotQueued(true)
                    end
                else
                    if self:GetOwner():KeyPressed(IN_ATTACK2) and self.TriggerSound then
                        self:EmitSound(self.TriggerSound, 75, 100, 1, CHAN_AUTO)
                    end

                    if self:GetOwner():KeyPressed(IN_ATTACK2) and rising_edge_firemodes[self.Firemode] then
                        self:SetShotQueued(true)
                    elseif self:GetOwner():KeyReleased(IN_ATTACK2) and falling_edge_firemodes[self.Firemode] then
                        self:SetShotQueued(true)
                    elseif self:GetOwner():KeyDown(IN_ATTACK2) and auto_firemodes[self.Firemode] then
                        self:SetShotQueued(true)
                    end
                end
            end

            if self:GetNeedCycle2() then
                if self:GetOwner():KeyDown(IN_WEAPON1) then
                    self:SetNeedCycle2(false)
                    self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                end
            else
                if self:Clip2() <= 0 then
                    if self:GetOwner():KeyPressed(IN_ATTACK) then
                        self:SetShot2Queued(true)
                    end
                else
                    if self:GetOwner():KeyPressed(IN_ATTACK) and self.TriggerSound then
                        self:EmitSound(self.TriggerSound, 75, 100, 1, CHAN_AUTO)
                    end

                    if self:GetOwner():KeyPressed(IN_ATTACK) and rising_edge_firemodes[self.Firemode] then
                        self:SetShot2Queued(true)
                    elseif self:GetOwner():KeyReleased(IN_ATTACK) and falling_edge_firemodes[self.Firemode] then
                        self:SetShot2Queued(true)
                    elseif self:GetOwner():KeyDown(IN_ATTACK) and auto_firemodes[self.Firemode] then
                        self:SetShot2Queued(true)
                    end
                end
            end
        end
    else
        if not self:GetReloading() then
            if self:GetNeedCycle() then
                if self:GetOwner():KeyDown(IN_WEAPON1) then
                    self:SetNeedCycle(false)
                    self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                end
            else
                if self:Clip1() <= 0 then
                    if self:GetOwner():KeyPressed(IN_ATTACK) then
                        self:SetShotQueued(true)
                    end
                else
                    if self:GetOwner():KeyPressed(IN_ATTACK) and self.TriggerSound then
                        self:EmitSound(self.TriggerSound, 75, 100, 1, CHAN_AUTO)
                    end

                    if self:GetOwner():KeyPressed(IN_ATTACK) and rising_edge_firemodes[self.Firemode] then
                        self:SetShotQueued(true)
                    elseif self:GetOwner():KeyReleased(IN_ATTACK) and falling_edge_firemodes[self.Firemode] then
                        self:SetShotQueued(true)
                    elseif self:GetOwner():KeyDown(IN_ATTACK) and auto_firemodes[self.Firemode] then
                        self:SetShotQueued(true)
                    end
                end
            end
        end
    end

    if self:GetShot2Queued() then
        self:Shoot(true)
    end

    if self:GetShotQueued() then
        self:Shoot()
    end

    if self:GetOwner():KeyPressed(IN_ZOOM) then
        self:ToggleAkimbo()
    end

    if self:GetOwner():KeyPressed(IN_RELOAD) then
        self:CustomReload()
    end

    if self:GetReloading() and (CurTime() >= (self:GetReloadTime() + self:GetMaximumReloadTime())) then
        self:FinishReload(true)
    end

    if self:GetReloading() and (CurTime() >= self:GetReloadTime() + self:GetMinimumReloadTime() + self.ReloadHintSoundDelay) and not self:GetPlayedReloadHint() then
        self:EmitSound(self.ReloadHintSound, 75, 100, 1, CHAN_AUTO)
        self:SetPlayedReloadHint(true)
    end
end