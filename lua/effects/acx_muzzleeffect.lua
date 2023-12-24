EFFECT.Mat = "effects/gunshipmuzzle"

EFFECT.SmokeMat = "particles/smokey"

EFFECT.StartTime = 0
EFFECT.Life = 1
EFFECT.Weapon = NULL
EFFECT.Left = false

function EFFECT:GetShouldPos()
    local vpos = self.Weapon:GetOwner():EyePos()
    local vang = self.Weapon:GetOwner():EyeAngles()

    local pos, ang = self.Weapon:GetCustomViewPos(vpos, vang, self.Left)

    pos = pos + ang:Right() * self.Weapon.MuzzleOffset.x
    pos = pos + ang:Forward() * self.Weapon.MuzzleOffset.y
    pos = pos + ang:Up() * self.Weapon.MuzzleOffset.z

    return pos, ang
end

function EFFECT:Init(data)
    local wpn = data:GetEntity()
    self.Weapon = wpn
    local ply = wpn:GetOwner()

    local left = data:GetFlags() == 1
    self.Left = left

    self.StartTime = CurTime()

    if !IsValid(wpn) then self:Remove() return end

    local pos, ang = self:GetShouldPos()

    local emitter = ParticleEmitter( pos )

    local particle = emitter:Add(self.Weapon.MuzzleTexture or self.Mat, pos)
    particle:SetAirResistance( 0 )
    particle:SetDieTime( 0.05 )
    particle:SetStartAlpha( 255 )
    particle:SetEndAlpha( 0 )
    particle:SetStartSize( 2 * wpn.MuzzleScale )
    particle:SetEndSize( 12 * wpn.MuzzleScale )
    particle:SetRoll( math.Rand(-1, 1) * 0.25 )
    particle:SetRollDelta( 0 )
    particle:SetColor( 255, 255, 255 )
    particle:SetNextThink( CurTime() + FrameTime() )
    particle.fx = self
    particle:SetThinkFunction( function(pa)
        if !pa then return end
        if !IsValid(wpn) then return end

        pa:SetPos(pa.fx:GetShouldPos())

        pa:SetNextThink( CurTime() + FrameTime() )
    end )

    local particle2 = emitter:Add(self.SmokeMat, pos)
    particle2:SetAirResistance( 0 )
    particle2:SetDieTime( 0.25 )
    particle2:SetStartAlpha( 20 )
    particle2:SetEndAlpha( 0 )
    particle2:SetStartSize( 4 )
    particle2:SetEndSize( 35 * wpn.MuzzleScale )
    particle2:SetRoll( math.Rand(-1, 1) )
    particle2:SetRollDelta( math.Rand(-1, 1) * 4 )
    particle2:SetColor( 255, 255, 255 )
    particle2:SetVelocity( ply:GetAbsVelocity() + ang:Forward() * 64 + VectorRand() * 8 )
    particle2:SetGravity( Vector(0, 0, 16) + VectorRand() * 8 )
    particle2:SetAirResistance( 64 )

    emitter:Finish()


    if !wpn.NoFlash then
        local light = DynamicLight(self.Weapon:GetOwner():EntIndex())
        local clr = Color(244, 209, 200)
        if (light) then
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
    if self.StartTime + self.Life < CurTime() then
        return false
    end

    return true
end

function EFFECT:Render()
    return false
end