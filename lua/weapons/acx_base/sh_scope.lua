function SWEP:ShouldAim()
    if self:GetReloading() then return false end
    if self:GetAkimbo() then return false end

    return self:GetOwner():KeyDown(IN_ATTACK2)
end

function SWEP:ToggleAim(aim)
    if aim then
        self:SetAiming(true)
    else
        self:SetAiming(false)
    end

    self:SetShouldHoldType()
end