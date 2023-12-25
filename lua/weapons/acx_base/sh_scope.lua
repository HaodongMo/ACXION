function SWEP:ShouldAim()
    if not IsValid(self:GetOwner()) then return false end
    if self:GetReloading() then return false end
    if self:GetAkimbo() then return false end

    return self:GetOwner():KeyDown(IN_ATTACK2)
end

function SWEP:ToggleAim(aim)
    self:SetAiming(aim)

    self:SetShouldHoldType()
end