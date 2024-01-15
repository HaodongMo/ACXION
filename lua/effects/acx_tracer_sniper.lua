EFFECT.StartPos = Vector(0, 0, 0)
EFFECT.EndPos = Vector(0, 0, 0)
EFFECT.StartTime = 0
EFFECT.LifeTime = 0.15
EFFECT.LifeTime2 = 0.15
EFFECT.DieTime = 0
EFFECT.Color = Color(255, 225, 100)
EFFECT.Speed = 30000

local head = Material("particle/fire")
local tracer = Material("acxion/tracer")

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
    local startpos = self.StartPos + (d * 0.2 * (self.EndPos - self.StartPos))
    local endpos = self.StartPos + (d * (self.EndPos - self.StartPos))

    local size = math.Clamp(math.log(EyePos():DistToSqr(endpos) - math.pow(256, 2)), 8, math.huge)

    local vel = self.Dir * self.Speed - LocalPlayer():GetVelocity()

    local dot = math.abs(EyeAngles():Forward():Dot(vel:GetNormalized()))
    local headsize = size * dot * 2

    local col = self.Color

    render.SetMaterial(head)
    render.DrawSprite(endpos, headsize, headsize, col)

    local tail = (self.Dir * math.min(512, (endpos - startpos):Length() - 32))

    render.SetMaterial(tracer)
    render.DrawBeam(endpos, endpos - tail, size * 1, 0, 1, col)

end
