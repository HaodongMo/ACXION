EFFECT.StartPos = Vector(0, 0, 0)
EFFECT.EndPos = Vector(0, 0, 0)
EFFECT.StartTime = 0
EFFECT.LifeTime = 0.15
EFFECT.LifeTime2 = 0.15
EFFECT.DieTime = 0
EFFECT.Color = Color(255, 255, 255)
EFFECT.Speed = 20000

local head = Material("particle/fire")

function EFFECT:Init(data)

    local hit = data:GetOrigin()
    self.Weapon = data:GetEntity()

    if !IsValid(self.Weapon) then return end

    local left = self.Weapon.ACX and self.Weapon:GetLastShotLeft()
    self.Left = left

    local start = data:GetStart()

    if self.Weapon.ACX then
        start = self.Weapon:FX_GetShouldPos(left)
    elseif !start then
        start = self.Weapon:GetPos() -- ???
    end

    local diff = hit - start
    local dist = diff:Length()

    self.LifeTime = dist / self.Speed
    self.StartTime = UnPredictedCurTime()
    self.DieTime = UnPredictedCurTime() + math.max(self.LifeTime, self.LifeTime2)

    self.StartPos = start
    self.EndPos = hit
    self.Dir = diff:GetNormalized()
end

function EFFECT:Think()
    return self.DieTime > UnPredictedCurTime()
end

function EFFECT:Render()

    if !self.Dir then return end

    local d = (UnPredictedCurTime() - self.StartTime) / self.LifeTime
    -- local startpos = self.StartPos + (d * 0.2 * (self.EndPos - self.StartPos))
    local endpos = self.StartPos + (d * (self.EndPos - self.StartPos))

    local size = 8

    local vel = self.Dir * self.Speed - LocalPlayer():GetVelocity()

    local dot = math.abs(EyeAngles():Forward():Dot(vel:GetNormalized()))
    local headsize = size * dot

    local col = self.Color

    render.SetMaterial(head)
    render.DrawSprite(endpos, headsize, headsize, col)
end