function SWEP:Reload()
    if self:GetOwner():IsNPC() then
        self:NPC_Reload()
        return
    end
end

function SWEP:CustomReload()
    if self:GetReloading() then self:FinishReload() return end

    local left = self:GetAkimbo() and self:Clip1() > self:Clip2()

    if self:GetStillWaiting(left) then return end
    local bonus = self.FastReloadBonus

    if not ACX.ConVars["dynamic_reload"]:GetBool() then
        bonus = 0
    end

    if (self:Clip1() >= self.Primary.ClipSize + bonus) and ((self:Clip2() >= self.Primary.ClipSize + bonus) or not self:GetAkimbo()) then return end
    if self:Ammo1() <= 0 then return end

    self:SetReloading(true)

    if self.BothReload  then
        left = false
    end

    self:SetReloading2(left)
    self:SetReloadTime(CurTime())
    self:SetPlayedReloadHint(false)
    self:SendCanFastReload()

    if self:GetAkimbo() then
        self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RELOAD_DUEL)
    else
        self:GetOwner():DoAnimationEvent(self.GestureReload)
    end

    self:SetNeedCycle(false)
    self:SetNeedCycle2(false)

    self:EmitSound(self.ReloadStartSound, 75, 100, 1, CHAN_AUTO)
end

function SWEP:FinishReload(slow)
    if not ACX.ConVars["dynamic_reload"]:GetBool() then slow = true end

    if self:GetReloading() then
        if self:GetReloadTime() + self:GetMinimumReloadTime() > CurTime() then return end

        local alt = self:GetReloading2()

        local limit = self.Primary.ClipSize

        if not slow then
            limit = limit + self.FastReloadBonus
        end

        local amount = limit

        if self.ShotgunReload then
            amount = 1
        end

        local amount_restored = 0

        if self.BothReload then
            if self:GetAkimbo() then
                local total = self:Clip1() + self:Clip2() + self:Ammo1()

                if total < limit * 2 then
                    limit = math.ceil(total / 2)
                end

                amount_restored = amount_restored + self:RestoreAmmo2(amount, limit)
            end
            amount_restored = amount_restored + self:RestoreAmmo(amount, limit)
        else
            if alt then
                amount_restored = amount_restored + self:RestoreAmmo2(amount, limit)
            else
                amount_restored = amount_restored + self:RestoreAmmo(amount, limit)
            end
        end

        if self.ShotgunReload then
            if self:Ammo1() <= 0 or (self:Clip1() >= limit and (self:Clip2() >= limit or not self:GetAkimbo())) then
                self:SetReloading(false)
            else
                self:SetReloading(true)
                self:SetReloadTime(CurTime())
                self:SetPlayedReloadHint(false)
                self:SendCanFastReload()
            end
        else
            self:SetReloading(false)
            if alt then
                self:SetWait2Time(CurTime() + self.HolsterTime + 0.1)
            else
                self:SetWaitTime(CurTime() + self.HolsterTime + 0.1)
            end
        end

        if amount_restored > 0 then
            self:EmitSound(self.ReloadFinishSound, 75, 100, 1, CHAN_AUTO)
        end

        -- interrupts ongoing reload anim
        if not self:GetReloading() then
            if slow then
                self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG)
            elseif alt then
                self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)
            else
                self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
            end
        end
    end
end

function SWEP:SendCanFastReload()
    if game.SinglePlayer() then self:CallOnClient("SendCanFastReload") end

    if not game.SinglePlayer() and not IsFirstTimePredicted() then return end

    ACX.FastReloadChance = true
    ACX.ReleasedReload = false

    ACX.CycleAmount = 0
    ACX.CycleAmount2 = 0
end

function SWEP:RestoreAmmo(amt, limit)
    if self:Clip1() >= limit then return 0 end
    local old = self:Clip1()

    local total = self:Clip1() + self:Ammo1()

    local restore = math.min(self:Clip1() + amt, total, limit or self.Primary.ClipSize)

    local newreserve = total - restore

    self:GetOwner():SetAmmo(newreserve, self.Primary.Ammo)
    self:SetClip1(restore)

    return restore - old
end

function SWEP:RestoreAmmo2(amt, limit)
    if self:Clip2() >= limit then return 0 end
    local old = self:Clip2()

    local total = self:Clip2() + self:Ammo1()

    local restore = math.min(self:Clip2() + amt, total, limit or self.Primary.ClipSize)

    local newreserve = total - restore

    self:GetOwner():SetAmmo(newreserve, self.Primary.Ammo)
    self:SetClip2(restore)

    return restore - old
end

function SWEP:GetMinimumReloadTime()
    return self.ReloadTime
end

function SWEP:GetMaximumFastReloadTime()
    return self.ReloadTime + 0.1 / self.ReloadDifficultyMult
end

function SWEP:GetMaximumReloadTime()
    if not ACX.ConVars["dynamic_reload"]:GetBool() then
        return self.ReloadTime
    else
        return self.ReloadTime * 1.75
    end
end

function SWEP:CancelReload()
    self:SetWaitTime(CurTime() + self.HolsterTime)
    self:SetWait2Time(CurTime() + self.HolsterTime)
    self:SetReloading(false)
end