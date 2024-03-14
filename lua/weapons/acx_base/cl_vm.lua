function SWEP:PreDrawViewModel(vm, weapon, ply)

    local should_draw_left = true
    local should_draw_right = true

    if self.IsGrenade and self:Ammo1() <= 0 then
        should_draw_left = false
        should_draw_right = false
    end

    if should_draw_left or should_draw_right then
        self:TryCreateModel()
    end

    local pos = EyePos()
    local ang = EyeAngles()

    local model_right = self.ModelRightView

    if IsValid(model_right) and should_draw_right then
        self:UpdateModelBodygroups(model_right)

        model_right:SetupBones()
        local vpos, vang = self:GetCustomViewPos(pos, ang)

        model_right:SetRenderOrigin(vpos)
        model_right:SetRenderAngles(vang)
        model_right:SetPos(vpos)
        model_right:SetAngles(vang)
    end

    local model_left = self.ModelLeftView

    if IsValid(model_left) and should_draw_left then
        self:UpdateModelBodygroups(model_left, true)

        model_left:SetupBones()

        local lvpos, lvang = self:GetCustomViewPos(pos, ang, true)

        model_left:SetRenderOrigin(lvpos)
        model_left:SetRenderAngles(lvang)
        model_left:SetPos(lvpos)
        model_left:SetAngles(lvang)
    end

    render.SetBlend(0)

    return false
end

function SWEP:GetViewModelPosition(pos, ang)
    return pos, ang
end

SWEP.InterpolatedLockAngle = Angle(0, 0, 0)
SWEP.InterpolatedLockAngle2 = Angle(0, 0, 0)

function SWEP:GetCustomViewPos(pos, ang, left, tracer)
    pos, ang = hook.Run("CalcViewModelView", self, self, Vector(pos), Angle(ang), pos, ang)

    local owner = self:GetOwner()
    left = left or false
    tracer = tracer or false
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

    local recoil_delta = self:GetRecoilDelta(left)

    -- so the tracer can come out of the gun pointing straight
    if recoil_delta > 0.95 and tracer then
        recoil_delta = 0
    end

    local lower_delta = self.LowerAmountRight

    if left then
        lower_delta = self.LowerAmountLeft
    end

    local aim_delta = self.SightAmount

    local viewOffsetZ = owner:GetViewOffset().z
    local crouchdelta = math.Clamp(math.ease.InOutSine((viewOffsetZ - owner:GetCurrentViewOffset().z) / (viewOffsetZ - owner:GetViewOffsetDucked().z)), 0, 1)

    local sway_offset

    if left then
        sway_offset = self:GetSwayOffsetLeft()
    else
        sway_offset = self:GetSwayOffsetRight()
    end

    pos = pos + right * self.ModelOffsetView.x * (1 - aim_delta)
    pos = pos + forward * self.ModelOffsetView.y
    pos = pos + up * self.ModelOffsetView.z
    pos = pos + right * self.AimOffset.x * aim_delta
    pos = pos + forward * self.AimOffset.y * aim_delta
    pos = pos + up * self.AimOffset.z * aim_delta
    pos = pos + right * self.RecoilOffset.x * recoil_delta
    pos = pos + forward * self.RecoilOffset.y * recoil_delta
    pos = pos + up * self.RecoilOffset.z * recoil_delta
    pos = pos + up * crouchdelta * -1.5
    pos = pos + up * lower_delta * self.HolsterOffset.x
    pos = pos + right * lower_delta * self.HolsterOffset.y
    pos = pos + forward * lower_delta * self.HolsterOffset.z
    pos = pos + right * sway_offset.x
    pos = pos + forward * sway_offset.y
    pos = pos + up * sway_offset.z
    local recoil_angle = self.RecoilAngle * recoil_delta
    ang:RotateAroundAxis(up, self.ModelAngleView.x + recoil_angle.x + lower_delta * self.HolsterAngle.p)
    ang:RotateAroundAxis(right, self.ModelAngleView.y + recoil_angle.y + lower_delta * self.HolsterAngle.y)
    ang:RotateAroundAxis(forward, self.ModelAngleView.z + recoil_angle.z + lower_delta * self.HolsterAngle.r)
    local aim_angle = self.AimAngle * aim_delta
    ang:RotateAroundAxis(up, aim_angle.x)
    ang:RotateAroundAxis(right, aim_angle.y)
    ang:RotateAroundAxis(forward, aim_angle.z)

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

    if self.SightAmount > 0 and self.HasScope then
        render.SetBlend(0)
    end

    local should_draw_left = true
    local should_draw_right = true

    if self.IsGrenade and self:Ammo1() <= 0 then
        should_draw_left = false
        should_draw_right = false
    end

    local model_right = self.ModelRightView
    if IsValid(model_right) and should_draw_right then
        model_right:SetupBones()
        model_right:DrawModel()
    end

    if self.LowerAmountLeft < 1 then
        local model_left = self.ModelLeftView
        if IsValid(model_left) and should_draw_left then
            model_left:SetupBones()
            model_left:DrawModel()
        end
    end

    render.SetBlend(1)

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