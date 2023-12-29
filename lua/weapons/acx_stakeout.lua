AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "Stakeout"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "Reliable but fiddly pump shotgun."
SWEP.TypeName = "Shotgun"

SWEP.Model = "models/tak/gtaiv/compact_shotgun.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.ModelOffsetView = Vector(5.5, 10, -5.5)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 2

----------------- Stats

SWEP.Damage = 15
SWEP.Num = 8
SWEP.HeadshotMultiplier = 1
SWEP.Spread = 0.04
SWEP.Recoil = 1
SWEP.RateOfFire = 300

SWEP.SpreadSightsMult = 0.5
SWEP.RecoilSightsMult = 0.5
SWEP.AutoAimSpeedSightsMult = 1

SWEP.SpreadAkimboMult = 1
SWEP.RecoilAkimboMult = 2
SWEP.AutoAimSpeedAkimboMult = 0.75

SWEP.Firemode = "pump"
-- auto
-- semi
-- semi_falling
-- binary
-- pump
-- bolt
-- burst_3, burst_2

SWEP.ReloadTime = 0.25
SWEP.ReloadDifficultyMult = 0.4
SWEP.ShotgunReload = true
SWEP.AkimboSingleReload = false

SWEP.AutoAimAngle = math.cos(math.rad(30))
SWEP.AutoAimRange = 3500
SWEP.AutoAimSpeed = 60

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 4

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(-0.1, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, -4, 0)
SWEP.RecoilAngle = Angle(0, 0, 0)

SWEP.CycleBetweenShots = true
SWEP.CycleDelay = 0.25

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.HoldType = "shotgun"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeAim = "ar2"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleTexture = "effects/fire_cloud2"

SWEP.MuzzleOffset = Vector(-3, 22, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = "acxion/wep/stakeout.ogg"
SWEP.ShootVolume = 110

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/m3/m3_pump.wav"
SWEP.ReloadFinishSound = "weapons/m3/m3_insertshell.wav"

SWEP.CycleSound = "weapons/m3/m3_pump.wav"