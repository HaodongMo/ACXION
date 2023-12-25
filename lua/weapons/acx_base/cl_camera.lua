function SWEP:CalcView(ply, pos, ang, fov)
    local magnification = Lerp(self.SightAmount, 1, self.Magnification)

    local recoil_delta = (self:GetNextPrimaryFire() - CurTime()) / (60 / self.RateOfFire)

    if recoil_delta < 0 then
        recoil_delta = 0
    end

    local recoil_delta2 = (self:GetNextSecondaryFire() - CurTime()) / (60 / self.RateOfFire)

    if recoil_delta2 < 0 then
        recoil_delta2 = 0
    end

    ang = ang + Angle((recoil_delta + recoil_delta2) * -0.6, 0, (math.sin(CurTime() * 10) * (recoil_delta + recoil_delta2)))

    self.TrueFOV = fov / magnification

    return pos, ang, fov / magnification
end