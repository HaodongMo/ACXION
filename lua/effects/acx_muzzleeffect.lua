EFFECT.Mat = "effects/gunshipmuzzle"
EFFECT.SmokeMat = "particles/smokey"
EFFECT.StartTime = 0
EFFECT.Life = 1
EFFECT.Weapon = NULL
EFFECT.Left = false

function EFFECT:Init(data)
    local wpn = data:GetEntity()
    self.Weapon = wpn
    local ply = wpn:GetOwner()
    local left = data:GetFlags() == 1
    self.Left = left
    self.StartTime = CurTime()

    if not IsValid(wpn) then
        self:Remove()

        return
    end

    local pos, ang = self.Weapon:FX_GetShouldPos(self.Left)
    local emitter = ParticleEmitter(pos)
    local particle = emitter:Add(self.Weapon.MuzzleTexture or self.Mat, pos)
    particle:SetAirResistance(0)
    particle:SetDieTime(0.05)
    particle:SetStartAlpha(255)
    particle:SetEndAlpha(0)
    particle:SetStartSize(2 * wpn.MuzzleScale)
    particle:SetEndSize(12 * wpn.MuzzleScale)
    particle:SetRoll(math.Rand(-1, 1) * 0.25)
    particle:SetRollDelta(0)
    particle:SetColor(255, 255, 255)
    particle:SetNextThink(CurTime() + FrameTime())
    particle.fx = self

    particle:SetThinkFunction(function(pa)
        if not pa then return end
        if not IsValid(wpn) then return end
        pa:SetPos(pa.fx.Weapon:FX_GetShouldPos(pa.fx.Left))
        pa:SetNextThink(CurTime() + FrameTime())
    end)

    local particle2 = emitter:Add(self.SmokeMat, pos)
    particle2:SetAirResistance(0)
    particle2:SetDieTime(0.25)
    particle2:SetStartAlpha(20)
    particle2:SetEndAlpha(0)
    particle2:SetStartSize(4)
    particle2:SetEndSize(35 * wpn.MuzzleScale)
    particle2:SetRoll(math.Rand(-1, 1))
    particle2:SetRollDelta(math.Rand(-1, 1) * 4)
    particle2:SetColor(255, 255, 255)
    local vel = ang:Forward() * 64 + VectorRand() * 8
    if IsValid(ply) then
        vel = vel + ply:GetVelocity()
    end
    particle2:SetVelocity(vel)
    particle2:SetGravity(Vector(0, 0, 16) + VectorRand() * 8)
    particle2:SetAirResistance(64)

    if self.Weapon:FX_IsThirdPerson() then
        emitter:Finish()
    else
        table.insert(self.Weapon.ParticleEmitters, emitter)
        emitter:SetNoDraw(true)

        table.insert(ACX.EmitterPile, {
            Emitter = emitter,
            Weapon = self.Weapon
        })
    end

    if not wpn.NoFlash then
        local light = DynamicLight(self.Weapon:GetOwner():EntIndex())
        local clr = Color(244, 209, 200)

        if light then
            light.Pos = pos
            light.r = clr.r
            light.g = clr.g
            light.b = clr.b
            light.Brightness = 2
            light.Decay = 2500
            light.Size = wpn:GetOwner() == LocalPlayer() and 256 or 128
            light.DieTime = CurTime() + 0.1
        end
    end
end

function EFFECT:Think()
    if self.StartTime + self.Life < CurTime() then return false end

    return true
end

function EFFECT:Render()
    return false
end