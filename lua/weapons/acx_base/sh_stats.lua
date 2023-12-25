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
    if self:GetAiming() then return self.Spread * 0.5 end
    return self.Spread
end

function SWEP:GetRecoil()
    if self:GetAiming() then return self.Recoil * 0.5 end
    return self.Recoil
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