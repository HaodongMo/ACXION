AddCSLuaFile()

SWEP.Spawnable = false
SWEP.Category = "ACXION"
SWEP.AdminOnly = false
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

----------------- Main Information

SWEP.PrintName = "ACXION Base"

-- Info box
SWEP.DrawWeaponInfoBox = true
SWEP.Description = ""
SWEP.TypeName = "Firearm"

SWEP.Model = ""
SWEP.Bodygroups = ""

SWEP.BulletBodygroups = {
    -- [1] = {5, 1}
}

SWEP.ModelOffsetView = Vector(0, 0, 0)
SWEP.ModelAngleView = Angle(0, 0, 0)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

----------------- Stats

SWEP.Damage = 30
SWEP.Num = 1
SWEP.HeadshotMultiplier = 2
SWEP.AmmoPerShot = 1
SWEP.Distance = 16000

SWEP.ProjectileEntity = nil
SWEP.ProjectileForce = 5000
SWEP.ProjectileAngle = Angle(0, 0, 0)

SWEP.Spread = 0.01
SWEP.Recoil = 1
SWEP.RateOfFire = 600
SWEP.BurstDelay = 0.1

-- Multiplier in sights
SWEP.SpreadSightsMult = 0.5
SWEP.RecoilSightsMult = 0.5
SWEP.AutoAimSpeedSightsMult = 1

-- Multiplier in akimbo
SWEP.CanAkimbo = true
SWEP.SpreadAkimboMult = 1.5
SWEP.RecoilAkimboMult = 1.25
SWEP.AutoAimSpeedAkimboMult = 1

SWEP.Sway = 1

SWEP.Firemode = "auto"
-- auto
-- semi
-- binary
-- pump
-- bolt
-- burst_3, burst_2, etc.

SWEP.ReloadTime = 1
SWEP.ReloadDifficultyMult = 1
SWEP.ShotgunReload = false
SWEP.AkimboSingleReload = true -- in akimbo, allows firing other gun while one is reloading
SWEP.BothReload = nil -- Both guns reload at once

SWEP.AutoAimAngle = math.cos(math.rad(15))
SWEP.AutoAimRange = 3500
SWEP.AutoAimSpeed = 1
SWEP.AutoAimSeek = "body"
-- "head", "body", "both"

SWEP.ProvideTargetData = true
SWEP.HardLockForTargetData = false -- Weapon must be directly aiming at a target to provide target data

SWEP.AutoAimOutOfSights = true
SWEP.AutoAimInSights = false

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 10 -- Extra rounds awarded for a fast reload

SWEP.CycleBetweenShots = false -- Manual bolt action mechanics :steamhappy:
SWEP.CycleDelay = 0.25

SWEP.Magnification = 1.5

SWEP.HasScope = false

SWEP.AimOffset = Vector(0, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, 0, 0)
SWEP.RecoilAngle = Angle(0, 0, 0)

SWEP.HolsterOffset = Vector(-4, 0, -16)
SWEP.HolsterAngle = Angle(-90, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.GestureShootLast = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.HoldType = "ar2"
SWEP.HoldTypeAim = "rpg"

SWEP.HolsterTime = 0.1

----------------- Effects

SWEP.TracerName = nil -- override default tracer. Set false to disable tracers

SWEP.MuzzleEffect = "acx_muzzleeffect"
SWEP.MuzzleTexture = "effects/gunshipmuzzle"

SWEP.MuzzleOffset = Vector(0, 0, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = ""
SWEP.ShootVolume = 110
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 5

SWEP.DryFireSound = ""
SWEP.TriggerSound = ""

SWEP.ReloadStartSound = ""
SWEP.ReloadHintSound = ""
SWEP.ReloadHintSoundDelay = 0
SWEP.ReloadFinishSound = ""

SWEP.CycleSound = ""

----------------- Boilerplate

SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false

SWEP.SwayScale = 0
SWEP.BobScale = 0

SWEP.LowerAmountRight = 1
SWEP.LowerAmountLeft = 1

SWEP.SightAmount = 0

SWEP.ACX = true

SWEP.UseHands = false
SWEP.NPCUsable = true

SWEP.IsGrenade = false

SWEP.ParticleEmitters = {}

local searchdir = "weapons/acx_base"

local function autoinclude(dir)
    local files, dirs = file.Find(searchdir .. "/*.lua", "LUA")

    for _, filename in pairs(files) do
        if filename == "shared.lua" then continue end
        local luatype = string.sub(filename, 1, 2)

        if luatype == "sv" then
            if SERVER then
                include(dir .. "/" .. filename)
            end
        elseif luatype == "cl" then
            AddCSLuaFile(dir .. "/" .. filename)
            if CLIENT then
                include(dir .. "/" .. filename)
            end
        else
            AddCSLuaFile(dir .. "/" .. filename)
            include(dir .. "/" .. filename)
        end
    end

    for _, path in pairs(dirs) do
        autoinclude(dir .. "/" .. path)
    end
end

autoinclude(searchdir)

function SWEP:SecondaryAttack()
    return
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "HolsterTime")
    self:NetworkVar("Float", 1, "WaitTime")
    self:NetworkVar("Float", 2, "ReloadTime")
    self:NetworkVar("Float", 3, "Wait2Time")

    self:NetworkVar("Int", 0, "BurstCount")
    self:NetworkVar("Int", 1, "Burst2Count")

    self:NetworkVar("Bool", 0, "ShotQueued")
    self:NetworkVar("Bool", 1, "Reloading")
    self:NetworkVar("Bool", 2, "Akimbo")
    self:NetworkVar("Bool", 3, "Reloading2")
    self:NetworkVar("Bool", 4, "Holstering")
    self:NetworkVar("Bool", 5, "PlayedReloadHint")
    self:NetworkVar("Bool", 6, "HeadLock")
    self:NetworkVar("Bool", 7, "Aiming")
    self:NetworkVar("Bool", 8, "Shot2Queued")
    self:NetworkVar("Bool", 9, "HeadLock2")
    self:NetworkVar("Bool", 10, "NeedCycle")
    self:NetworkVar("Bool", 11, "NeedCycle2")
    self:NetworkVar("Bool", 12, "LastShotLeft")
    self:NetworkVar("Bool", 13, "SecondGunAvailable")

    self:NetworkVar("Entity", 0, "HolsterEntity")
    self:NetworkVar("Entity", 1, "LockOnEntity")
    self:NetworkVar("Entity", 2, "LockOnEntity2")

    self:NetworkVar("Vector", 0, "LockOnVector")
    self:NetworkVar("Vector", 1, "LockOnVector2")
end