function SWEP:GetShouldRaiseRight()
    if self:GetHolstering() then return false end
    if self:GetReloading() then return false end

    return true
end

function SWEP:GetShouldRaiseLeft()
    if self:GetHolstering() then return false end
    if self:GetReloading() then return false end
    if not self:GetAkimbo() then return false end

    return true
end

function SWEP:Initialize()
    self.Secondary.ClipSize = self.Primary.ClipSize
end

function SWEP:Deploy()
    if game.SinglePlayer() then self:CallOnClient("Deploy") end

    self.LowerAmountRight = 1
    self.LowerAmountLeft = 1

    self:SetHolstering(false)

    self:SetBurstCount(0)

    self:GetOwner():SetCanZoom(false)

    return true
end

function SWEP:Holster(wep)
    if game.SinglePlayer() and CLIENT then return end

    if self:GetHolsterTime() > CurTime() then return false end

    self:SetReloading(false)

    if (self:GetHolsterTime() != 0 and self:GetHolsterTime() <= CurTime()) or !IsValid(wep) then
        -- Do the final holster request
        -- Picking up props try to switch to NULL, by the way
        self:SetHolsterTime(0)
        self:SetHolsterEntity(NULL)
        self:GetOwner():SetCanZoom(true)

        return true
    else
        self:SetHolsterTime(CurTime() + (self.HolsterTime))
        self:SetHolsterEntity(wep)
        self:SetHolstering(true)
    end
end

