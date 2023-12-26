function SWEP:GetDamage()
    return self.Damage
end

function SWEP:GetHeadshotMultiplier()
    return self.HeadshotMultiplier
end

function SWEP:GetNum()
    return self.Num
end

function SWEP:GetSpread()
    local spr = self.Spread
    if self:GetAkimbo() then
        spr = spr * self.SpreadAkimboMult
    elseif self:GetAiming() then
        spr = spr * self.SpreadSightsMult
    end
    return spr
end

function SWEP:GetRecoil()
    local rec = self.Recoil
    if self:GetAkimbo() then
        rec = rec * self.RecoilAkimboMult
    elseif self:GetAiming() then
        rec = rec * self.RecoilSightsMult
    end
    return rec
end

function SWEP:GetRateOfFire()
    return self.RateOfFire
end

function SWEP:GetProjectileEntity()
    return self.ProjectileEntity
end

function SWEP:GetProjectileForce()
    return self.ProjectileForce
end

function SWEP:GetAutoAimSpeed()
    local aas = self.AutoAimSpeed
    if self:GetAkimbo() then
        aas = aas * self.AutoAimSpeedAkimboMult
    elseif self:GetAiming() then
        aas = aas * self.AutoAimSpeedSightsMult
    end
    return aas
end