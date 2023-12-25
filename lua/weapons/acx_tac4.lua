AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "TAC-4"
SWEP.Category = "ACXION"

SWEP.Model = "models/tak/gtaiv/remington_1100_tac_4.mdl"

SWEP.ModelOffsetView = Vector(3, 4, -5)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(0, 0, 0)
SWEP.ModelAngleWorld = Angle(0, 0, 0)

----------------- Stats

SWEP.Damage = 15
SWEP.Num = 8
SWEP.HeadshotMultiplier = 1
SWEP.ArmorPiercing = 0
SWEP.Spread = 0.04
SWEP.Recoil = 1
SWEP.RateOfFire = 350

SWEP.Firemode = "semi"
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

SWEP.AutoAimAngle = math.cos(math.rad(30))
SWEP.AutoAimRange = 3500
SWEP.AutoAimSpeed = 60

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 0

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(0, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, -8, 0)
SWEP.RecoilAngle = Angle(0, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.HoldType = "ar2"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeAim = "rpg"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleTexture = "effects/fire_cloud2"

SWEP.MuzzleOffset = Vector(-3.5, 14, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = "weapons/xm1014/xm1014-1.wav"
SWEP.ShootVolume = 110
SWEP.ShootPitch = 100

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/sg552/sg552_boltpull.wav"
SWEP.ReloadFinishSound = "weapons/m3/m3_insertshell.wav"