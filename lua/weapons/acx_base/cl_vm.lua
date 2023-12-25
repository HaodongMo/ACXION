function SWEP:PreDrawViewModel(vm, weapon, ply)

    self:TryCreateModel()

    local model_right = self.ModelRightView

    self:UpdateModelBodygroups(model_right)

    model_right:SetupBones()

    local pos = EyePos()
    local ang = EyeAngles()
    local vpos, vang = self:GetCustomViewPos(pos, ang)

    model_right:SetRenderOrigin(vpos)
    model_right:SetRenderAngles(vang)
    model_right:SetPos(vpos)
    model_right:SetAngles(vang)

    local model_left = self.ModelLeftView

    self:UpdateModelBodygroups(model_left, true)

    model_left:SetupBones()

    local lvpos, lvang = self:GetCustomViewPos(pos, ang, true)

    model_left:SetRenderOrigin(lvpos)
    model_left:SetRenderAngles(lvang)
    model_left:SetPos(lvpos)
    model_left:SetAngles(lvang)

    render.SetBlend(0)

    return false
end

function SWEP:GetViewModelPosition(pos, ang)
    pos = pos - ang:Forward() * 32

    return pos, ang
end

SWEP.InterpolatedLockAngle = Angle(0, 0, 0)
SWEP.InterpolatedLockAngle2 = Angle(0, 0, 0)

function SWEP:GetCustomViewPos(pos, ang, left)
    local owner = self:GetOwner()
    left = left or false
    local old_ang = Angle(ang)

    if left then
        ang = ang - owner:GetViewPunchAngles() * 2 - self.InterpolatedLockAngle2
    else
        ang = ang - owner:GetViewPunchAngles() * 2 - self.InterpolatedLockAngle
    end

    local up, right, forward = ang:Up(), ang:Right(), ang:Forward()

    if left then
        right = right * -1
    end

    local recoil_delta

    if left then
        recoil_delta = (self:GetNextSecondaryFire() - CurTime()) / (60 / self.RateOfFire)
    else
        recoil_delta = (self:GetNextPrimaryFire() - CurTime()) / (60 / self.RateOfFire)
    end

    if recoil_delta < 0 then
        recoil_delta = 0
    end

    local lower_delta = self.LowerAmountRight

    if left then
        lower_delta = self.LowerAmountLeft
    end

    local viewOffsetZ = owner:GetViewOffset().z
    local crouchdelta = math.Clamp(math.ease.InOutSine((viewOffsetZ - owner:GetCurrentViewOffset().z) / (viewOffsetZ - owner:GetViewOffsetDucked().z)), 0, 1)

    pos = pos + right * self.ModelOffsetView.x
    pos = pos + forward * self.ModelOffsetView.y
    pos = pos + up * self.ModelOffsetView.z
    pos = pos + right * self.RecoilOffset.x * recoil_delta
    pos = pos + forward * self.RecoilOffset.y * recoil_delta
    pos = pos + up * self.RecoilOffset.z * recoil_delta
    pos = pos + up * crouchdelta * -1.5
    pos = pos + up * lower_delta * self.HolsterOffset.x
    pos = pos + right * lower_delta * self.HolsterOffset.y
    pos = pos + forward * lower_delta * self.HolsterOffset.z
    local recoil_angle = self.RecoilAngle * recoil_delta
    ang:RotateAroundAxis(up, self.ModelAngleView.x + recoil_angle.x + lower_delta * self.HolsterAngle.p)
    ang:RotateAroundAxis(right, self.ModelAngleView.y + recoil_angle.y + lower_delta * self.HolsterAngle.y)
    ang:RotateAroundAxis(forward, self.ModelAngleView.z + recoil_angle.z + lower_delta * self.HolsterAngle.r)
    pos, ang = self:DoSway(pos, ang, old_ang)

    return pos, ang
end

function SWEP:DrawParticles()
    local newemitters = {}

    for _, emitter in ipairs(self.ParticleEmitters) do
        if IsValid(emitter) then
            emitter:Draw()

            if emitter:GetNumActiveParticles() < 1 then
                emitter:Finish()
            else
                table.insert(newemitters, emitter)
            end
        end
    end

    self.ParticleEmitters = newemitters
end

function SWEP:PostDrawViewModel(vm, weapon, ply)
    render.SetBlend(1)

    local model_right = self.ModelRightView
    model_right:SetupBones()
    model_right:DrawModel()

    if self.LowerAmountLeft < 1 then
        local model_left = self.ModelLeftView
        model_left:SetupBones()
        model_left:DrawModel()
    end

    self:DrawParticles()
end

SWEP.SwayVelocity = 0
SWEP.SwayCT = 0

function SWEP:DoSway(pos, ang, objective_ang)
    local up, right, forward = objective_ang:Up(), objective_ang:Right(), objective_ang:Forward()
    local velocity = self:GetOwner():GetVelocity():Length()

    if not self:GetOwner():IsOnGround() then
        velocity = velocity * 0.25
    end

    velocity = math.Clamp(velocity, 0, 500)
    self.SwayVelocity = math.Approach(self.SwayVelocity, velocity, FrameTime() * 2000)
    pos = pos + right * math.sin(self.SwayCT * 0.5) * self.SwayVelocity * 0.001
    pos = pos + up * math.cos(self.SwayCT) * self.SwayVelocity * 0.001
    self.SwayCT = self.SwayCT + FrameTime() * self.SwayVelocity * 0.04

    return pos, ang
end