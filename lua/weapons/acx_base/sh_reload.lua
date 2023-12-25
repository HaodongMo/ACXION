function SWEP:Reload()
end

function SWEP:CustomReload()
    if self:GetReloading() then self:FinishReload() return end

    if self:GetStillWaiting() then return end
    if (self:Clip1() >= self.Primary.ClipSize + self.FastReloadBonus) and ((self:Clip2() >= self.Primary.ClipSize + self.FastReloadBonus) or not self:GetAkimbo()) then return end
    if self:Ammo1() <= 0 then return end

    self:SetReloading(true)
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
    if self:GetReloading() then
        if self:GetReloadTime() + self:GetMinimumReloadTime() > CurTime() then return end

        local limit = self.Primary.ClipSize

        if not slow then
            limit = limit + self.FastReloadBonus
        end

        if self:GetAkimbo() then
            local total = self:Clip1() + self:Clip2() + self:Ammo1()

            if total < limit * 2 then
                limit = math.ceil(total / 2)
            end
        end

        local amount = limit

        if self.ShotgunReload then
            amount = 1
        end

        local amount_restored = 0

        amount_restored = amount_restored + self:RestoreAmmo(amount, limit)
        if self:GetAkimbo() then
            amount_restored = amount_restored + self:RestoreAmmo2(amount, limit)
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
            self:SetWaitTime(CurTime() + self.HolsterTime + 0.1)
            self:SetWait2Time(CurTime() + self.HolsterTime)
        end

        if amount_restored > 0 then
            self:EmitSound(self.ReloadFinishSound, 75, 100, 1, CHAN_AUTO)
        end
    end
end

function SWEP:SendCanFastReload()
    if game.SinglePlayer() then self:CallOnClient("SendCanFastReload") end

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
    return self.ReloadTime * 1.75
end

function SWEP:CancelReload()
    self:SetWaitTime(CurTime() + self.HolsterTime)
    self:SetWait2Time(CurTime() + self.HolsterTime)
    self:SetReloading(false)
end