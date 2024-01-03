function SWEP:CalcView(ply, pos, ang, fov)
    local magnification = Lerp(self.SightAmount, 1, self.Magnification)

    local recoil_delta = self:GetRecoilDelta()
    local recoil_delta2 = self:GetRecoilDelta(true)

    ang = ang + Angle((recoil_delta + recoil_delta2) * -0.6, 0, (math.sin(CurTime() * 10) * (recoil_delta + recoil_delta2)))

    self.TrueFOV = fov / magnification

    return pos, ang, fov / magnification
end