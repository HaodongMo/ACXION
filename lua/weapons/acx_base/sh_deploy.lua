function SWEP:GetShouldRaiseRight()
    if self:GetHolstering() then return false end
    if self:GetReloading() and (not self.AkimboSingleReload or not self:GetReloading2()) then return false end

    return true
end

function SWEP:GetShouldRaiseLeft()
    if self:GetHolstering() then return false end
    if self:GetReloading() and (not self.AkimboSingleReload or self:GetReloading2()) then return false end
    if not self:GetAkimbo() then return false end

    return true
end

function SWEP:Initialize()
    self:SetHolstering(false)
    self:SetBurstCount(0)
    self:SetShouldHoldType()

    self:SetShotQueued(false)

    self:SetReloadTime(0)

    self:SetBurstCount(0)
    self:SetBurst2Count(0)

    self:SetNeedCycle(false)
    self:SetNeedCycle2(false)

    self:SetNextPrimaryFire(0)
    self:SetNextSecondaryFire(0)

    self:SetWaitTime(0)
    self:SetWait2Time(0)

    self:SetLockOnEntity(NULL)
    self:SetLockOnEntity2(NULL)

    self:SetLockOnVector(Vector(0, 0, 0))
    self:SetLockOnVector2(Vector(0, 0, 0))

    self:SetReloading(false)
    self:SetReloading2(false)
    self:SetAiming(false)
    self:SetLastShotLeft(false)

    self.Secondary.ClipSize = self.Primary.ClipSize
    self.WorldModel = self.Model
    self:SetShouldHoldType()
end

function SWEP:Deploy()
    if game.SinglePlayer() then
        self:CallOnClient("Deploy")
    end

    if IsFirstTimePredicted() then
        self.LowerAmountRight = 1
        self.LowerAmountLeft = 1
    end

    self:SetHolstering(false)
    self:SetBurstCount(0)
    self:GetOwner():SetCanZoom(false)
    self:SetShouldHoldType()

    self:SetNeedCycle(false)
    self:SetNeedCycle2(false)

    self:SetNextPrimaryFire(0)
    self:SetNextSecondaryFire(0)

    self:SetWaitTime(CurTime() + self.HolsterTime)
    self:SetWait2Time(CurTime() + self.HolsterTime)

    self:SetLockOnEntity(NULL)
    self:SetLockOnEntity2(NULL)

    self:SetLockOnVector(Vector(0, 0, 0))
    self:SetLockOnVector2(Vector(0, 0, 0))

    self:SetReloading(false)
    self:SetReloading2(false)
    self:SetAiming(false)
    self:SetLastShotLeft(false)

    return true
end

function SWEP:Holster(wep)
    if game.SinglePlayer() and CLIENT then return end
    if self:GetHolsterTime() > CurTime() then return false end
    self:SetReloading(false)

    if (self:GetHolsterTime() ~= 0 and self:GetHolsterTime() <= CurTime()) or not IsValid(wep) then
        -- Do the final holster request
        -- Picking up props try to switch to NULL, by the way
        self:SetHolsterTime(0)
        self:SetHolsterEntity(NULL)
        self:GetOwner():SetCanZoom(true)

        return true
    else
        self:SetHolsterTime(CurTime() + self.HolsterTime)
        self:SetHolsterEntity(wep)
        self:SetHolstering(true)
    end
end

function SWEP:SetShouldHoldType()
    local ht = self.HoldType

    if self:ShouldAim() then
        ht = self.HoldTypeAim
    end

    if self:GetAkimbo() then
        ht = "duel"
    end

    self:SetHoldType(ht)
end