local rising_edge_firemodes = {
    ["semi"] = true,
    ["binary"] = true,
    ["pump"] = true,
    ["bolt"] = true,
    ["burst_"] = true,
    ["break"] = true,
    ["single"] = true,
    ["melee"] = true
}

local falling_edge_firemodes = {
    ["semi_falling"] = true,
    ["binary"] = true,
    ["throwable"] = true
}

local auto_firemodes = {
    ["auto"] = true
}

function SWEP:FiremodeEdge(edge)
    if edge then
        return rising_edge_firemodes[self.Firemode] or string.sub(self.Firemode, 1, 6) == "burst_"
    else
        return falling_edge_firemodes[self.Firemode]
    end
end

function SWEP:Think()
    local owner = self:GetOwner()
    if owner:IsNPC() then return end

    if not IsValid(owner) then return false end

    if self:ShouldAim() and not self:GetAiming() then
        self:ToggleAim(true)
    elseif not self:ShouldAim() and self:GetAiming() then
        self:ToggleAim(false)
    end

    if owner:IsPlayer() then
        owner:LagCompensation(true)
    end

    self:ThinkLockOn()

    if owner:IsPlayer() then
        owner:LagCompensation(false)
    end

    if CLIENT and owner == LocalPlayer() and (IsFirstTimePredicted() or game.SinglePlayer()) then
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

        local r = 9.9999 * FrameTime()
        self.InterpolatedLockAngle = LerpAngle(r, self.InterpolatedLockAngle, self:GetLockAngle())
        self.InterpolatedLockAngle2 = LerpAngle(r, self.InterpolatedLockAngle2, self:GetLockAngle2())
    end

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

        if self:GetReloading() and (not self.AkimboSingleReload or not self:GetReloading2()) then
            if owner:KeyPressed(IN_ATTACK2) then
                self:CancelReload()
            end
        elseif self:GetNeedCycle() then
            if not self:GetStillWaiting() and (ACX.ConVars["cycle"]:GetInt() == 0 and not owner:KeyDown(IN_ATTACK2) or (ACX.ConVars["cycle"]:GetInt() == 1 and owner:KeyPressed(IN_ATTACK2))) then
                self:SetNeedCycle(false)
                self:SetWaitTime(CurTime() + self.CycleDelay)
                self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
            elseif ACX.ConVars["cycle"]:GetInt() == 2 and owner:KeyDown(IN_WEAPON2) then
                self:SetNeedCycle(false)
                self:SetWaitTime(CurTime() + self.CycleDelay)
                self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
            end
        else
            if self:Clip1() <= 0 then
                if owner:KeyPressed(IN_ATTACK2) then
                    self:SetShotQueued(true)
                end
            else
                if self.TriggerSound and owner:KeyPressed(IN_ATTACK2) then
                    self:EmitSound(self.TriggerSound, 75, 100, 1, CHAN_AUTO)
                end

                if owner:KeyPressed(IN_ATTACK2) and rising_edge_firemodes[self.Firemode] then
                    self:SetShotQueued(true)
                elseif owner:KeyReleased(IN_ATTACK2) and falling_edge_firemodes[self.Firemode] then
                    self:SetShotQueued(true)
                elseif owner:KeyDown(IN_ATTACK2) and auto_firemodes[self.Firemode] then
                    self:SetShotQueued(true)
                end
            end
        end

        if self:GetReloading() and (not self.AkimboSingleReload or self:GetReloading2()) then
            if owner:KeyPressed(IN_ATTACK) then
                self:CancelReload()
            end
        elseif self:GetNeedCycle2() then
            if not self:GetStillWaiting(true) and (ACX.ConVars["cycle"]:GetInt() == 0 and not owner:KeyDown(IN_ATTACK) or (ACX.ConVars["cycle"]:GetInt() == 1 and owner:KeyPressed(IN_ATTACK))) then
                self:SetNeedCycle2(false)
                self:SetWait2Time(CurTime() + self.CycleDelay)
                self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
            elseif ACX.ConVars["cycle"]:GetInt() == 2 and owner:KeyDown(IN_WEAPON1) then
                self:SetNeedCycle2(false)
                self:SetWait2Time(CurTime() + self.CycleDelay)
                self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
            end
        else
            if self:Clip2() <= 0 then
                if owner:KeyPressed(IN_ATTACK) then
                    self:SetShot2Queued(true)
                end
            else
                if self.TriggerSound and owner:KeyPressed(IN_ATTACK) then
                    self:EmitSound(self.TriggerSound, 75, 100, 1, CHAN_AUTO)
                end

                if owner:KeyPressed(IN_ATTACK) and self:FiremodeEdge(true) then
                    self:SetShot2Queued(true)
                elseif owner:KeyReleased(IN_ATTACK) and self:FiremodeEdge(false) then
                    self:SetShot2Queued(true)
                elseif owner:KeyDown(IN_ATTACK) and auto_firemodes[self.Firemode] then
                    self:SetShot2Queued(true)
                end
            end
        end
    else
        if not self:GetReloading() then
            if self:GetNeedCycle() then
                if not self:GetStillWaiting() and ((ACX.ConVars["cycle"]:GetInt() == 0 and not owner:KeyDown(IN_ATTACK)) or (ACX.ConVars["cycle"]:GetInt() == 1 and owner:KeyPressed(IN_ATTACK))) then
                    self:SetNeedCycle(false)
                    self:SetWaitTime(CurTime() + self.CycleDelay)
                    self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                    self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
                elseif ACX.ConVars["cycle"]:GetInt() == 2 and owner:KeyDown(IN_WEAPON1) then
                    self:SetNeedCycle(false)
                    self:SetWaitTime(CurTime() + self.CycleDelay)
                    self:EmitSound(self.CycleSound, 75, 100, 1, CHAN_AUTO)
                    self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
                end
            else
                if self:Clip1() <= 0 then
                    if owner:KeyPressed(IN_ATTACK) then
                        self:SetShotQueued(true)
                    end
                else
                    if owner:KeyPressed(IN_ATTACK) and self.TriggerSound then
                        self:EmitSound(self.TriggerSound, 75, 100, 1, CHAN_AUTO)
                    end

                    if owner:KeyPressed(IN_ATTACK) and self:FiremodeEdge(true) then
                        self:SetShotQueued(true)
                    elseif owner:KeyReleased(IN_ATTACK) and self:FiremodeEdge(false) then
                        self:SetShotQueued(true)
                    elseif owner:KeyDown(IN_ATTACK) and auto_firemodes[self.Firemode] then
                        self:SetShotQueued(true)
                    end
                end
            end
        else
            if owner:KeyPressed(IN_ATTACK) then
                self:CancelReload()
            end
        end
    end

    if owner:IsPlayer() then
        owner:LagCompensation(true)
    end

        if self:GetShot2Queued() then
            self:Shoot(true)
            self:SetShot2Queued(false)
        end

        if self:GetShotQueued() then
            self:Shoot()
            self:SetShotQueued(false)
        end

    if owner:IsPlayer() then
        owner:LagCompensation(false)
    end

    if owner:KeyPressed(IN_ZOOM) then
        self:ToggleAkimbo()
    end

    if owner:KeyPressed(IN_RELOAD) then
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