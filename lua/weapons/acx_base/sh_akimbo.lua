function SWEP:ToggleAkimbo()
    local akimbo = self:GetAkimbo()

    if akimbo then
        self:SetAkimbo(false)

        self.Secondary.ClipSize = -1
        self.Secondary.Ammo = nil
    else
        self:SetAkimbo(true)

        self.Secondary.ClipSize = self.Primary.ClipSize
        self.Secondary.Ammo = self.Primary.Ammo
    end
end