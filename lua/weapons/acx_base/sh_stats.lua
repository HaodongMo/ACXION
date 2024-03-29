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

-- auto
-- semi
-- binary
-- pump
-- bolt
-- burst_3, burst_2, etc.
local lookup = {
    ["auto"] = "Automatic",
    ["semi"] = "Semi-auto",
    ["binary"] = "Binary-trigger",
    ["pump"] = "Pump-action",
    ["bolt"] = "Bolt-action",
    ["burst"] = "Burst-fire",
    ["single"] = "Single-shot",
    ["break"] = "Break-action",
    ["throwable"] = "Throwable",
    ["melee"] = "Melee",
    ["none"] = "None"
}
function SWEP:GetFiremodeName()
    local fm = self.Firemode
    if string.Left(fm, 6) == "burst_" then fm = "burst" end
    return lookup[fm] or fm
end

function SWEP:GetSwayOffsetRight()
    return Vector(math.sin(CurTime() * 1) * self.Sway, 0, math.cos(CurTime() * 1.5) * self.Sway) * 0.1
end

function SWEP:GetSwayOffsetLeft()
    return Vector(math.sin(CurTime() * 1.1) * self.Sway, 0, math.cos(CurTime() * 1.3) * self.Sway) * 0.1
end

function SWEP:GetPingOffsetScale()
    if game.SinglePlayer() then return 0 end

    return (self:GetOwner():Ping() - 5) / 1000
end

function SWEP:GetRecoilDelta(left)
    local recoil_delta

    local nextfire

    if left then
        nextfire = self:GetNextSecondaryFire()
    else
        nextfire = self:GetNextPrimaryFire()
    end

    local recoil = math.max(self.Recoil, 0.1)

    if game.SinglePlayer() then
        recoil_delta = (nextfire - CurTime()) / (0.2 * recoil)
    else
        recoil_delta = (nextfire - CurTime() - self:GetPingOffsetScale()) / (0.2 * recoil)
    end

    if recoil_delta < 0 then
        recoil_delta = 0
    end

    return recoil_delta
end

function SWEP:GetTraceFilter()
    local filter = {}
    table.insert(filter, self:GetOwner())
    table.insert(filter, self)
    if self:GetOwner():GetVehicle() then
        table.insert(filter, self:GetOwner():GetVehicle())

        for _, v in pairs(self:GetOwner():GetVehicle():GetChildren()) do
            table.insert(filter, v)
        end
    end
    return filter
end