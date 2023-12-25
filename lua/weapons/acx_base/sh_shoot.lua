-- We use our own custom functions to handle these!
function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:GetStillWaiting(left)
    if left then
        if self:GetNextSecondaryFire() > CurTime() then return true end
        if self:GetWait2Time() > CurTime() then return true end
    else
        if self:GetNextPrimaryFire() > CurTime() then return true end
        if self:GetWaitTime() > CurTime() then return true end
    end

    if self:GetReloading() then return true end

    return false
end

function SWEP:Shoot(left)
    if self:GetStillWaiting(left) then return end

    if left then
        if self:GetNeedCycle2() then return end

        if self:Clip2() <= 0 then
            self:DryFire(true)
            return
        end
    else
        if self:GetNeedCycle() then return end

        if self:Clip1() <= 0 then
            self:DryFire()
            return
        end
    end

    local spread = self.Spread

    local ang

    if left then
        ang = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles() - self:GetLockAngle2()
    else
        ang = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles() - self:GetLockAngle()
    end

    local damage = self.Damage

    -- "Lucky Last" - Last 10% of the magazine starts to ramp up damage up to 50% more

    if left then
        if self:Clip2() <= self.Primary.ClipSize * 0.1 then
            damage = damage + (damage * (0.5 * (1 - (self:Clip2() / (self.Primary.ClipSize * 0.1)))))
        end
    else
        if self:Clip1() <= self.Primary.ClipSize * 0.1 then
            damage = damage + (damage * (0.5 * (1 - (self:Clip1() / (self.Primary.ClipSize * 0.1)))))
        end
    end

    local bullet = {
        Attacker = self:GetOwner(),
        Damage = damage,
        Force = damage / 3,
        Num = self.Num,
        Tracer = 0,
        Dir = ang:Forward(),
        Src = self:GetOwner():EyePos(),
        Spread = Vector(spread, spread, 0),
        Distance = 50000,
        Callback = function(attacker, tr, dmginfo)
            local dmg = dmginfo:GetDamage()

            if tr.HitGroup == HITGROUP_HEAD then
                dmg = dmg * self.HeadshotMultiplier
            end

            dmginfo:SetDamage(dmg)
        end
    }

    if left then
        self:SetNextSecondaryFire(CurTime() + (60 / self.RateOfFire))
    else
        self:SetNextPrimaryFire(CurTime() + (60 / self.RateOfFire))
    end

    if IsFirstTimePredicted() then
        self:DoMuzzleEffects(left)

        local punchAngle = Angle(util.SharedRandom("acx_recoil_left", -1, 1, self:GetOwner():GetCurrentCommand()) * self.Recoil, util.SharedRandom("acx_recoil_up", -1, 1, self:GetOwner():GetCurrentCommand()) * self.Recoil, 0.5 * math.Rand(-1, 1) * self.Recoil)

        if left then
            self:TakeSecondaryAmmo(1)
            self:SetBurst2Count(self:GetBurst2Count() + 1)
        else
            self:TakePrimaryAmmo(1)
            self:SetBurstCount(self:GetBurstCount() + 1)
        end

        self:GetOwner():ViewPunch(punchAngle)

        self:GetOwner():FireBullets(bullet)
    end

    self:GetOwner():DoAnimationEvent(self.GestureShoot)

    self:EmitSound(self.ShootSound, self.ShootVolume, self.ShootPitch + (math.Rand(-1, 1) * self.ShootPitchVariation), 1, CHAN_WEAPON)

    if left then
        self:SetShot2Queued(false)
    else
        self:SetShotQueued(false)
    end

    if self.CycleBetweenShots then
        if left then
            self:SetNeedCycle2(true)
        else
            self:SetNeedCycle(true)
        end
        if self:GetAkimbo() then
            if left then
                self:SendNeedCycle()
            else
                self:SendNeedCycle2()
            end
        else
            self:SendNeedCycle()
        end
    end
end

function SWEP:DryFire(left)
    self:EmitSound(self.DryFireSound, 75, 100, 1, CHAN_ITEM)

    if left then
        self:SetShot2Queued(false)
        self:SetBurst2Count(0)
    else
        self:SetShotQueued(false)
        self:SetBurstCount(0)
    end
end

function SWEP:SendNeedCycle()
    if game.SinglePlayer() then self:CallOnClient("SendNeedCycle") end

    ACX.CycleAmount = 0
end

function SWEP:SendNeedCycle2()
    if game.SinglePlayer() then self:CallOnClient("SendNeedCycle2") end

    ACX.CycleAmount2 = 0
end

function SWEP:DoMuzzleEffects(left)
    if !IsFirstTimePredicted() then return end

    local data = EffectData()
    data:SetEntity(self)
    data:SetFlags(left and 1 or 0)

    util.Effect( self.MuzzleEffect, data )
end