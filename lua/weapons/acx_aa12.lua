AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "AA-12"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "Massive magazine and spread for buckshot saturation."
SWEP.TypeName = "Shotgun"

SWEP.Model = "models/tak/gtaiv/aa-12.mdl"
SWEP.WorldModel = SWEP.Model
SWEP.Bodygroups = "0002"

SWEP.ModelOffsetView = Vector(4, 9, -8)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 2

----------------- Stats

SWEP.Damage = 12
SWEP.Num = 5
SWEP.HeadshotMultiplier = 1
SWEP.Spread = 0.06
SWEP.Recoil = 1.5
SWEP.RateOfFire = 450

SWEP.SpreadSightsMult = 0.75
SWEP.RecoilSightsMult = 0.5
SWEP.AutoAimSpeedSightsMult = 1

SWEP.SpreadAkimboMult = 1.25
SWEP.RecoilAkimboMult = 2
SWEP.AutoAimSpeedAkimboMult = 0.75

SWEP.Firemode = "auto"
-- auto
-- semi
-- semi_falling
-- binary
-- pump
-- bolt
-- burst_3, burst_2

SWEP.ReloadTime = 1
SWEP.ReloadDifficultyMult = 1
SWEP.ShotgunReload = false
SWEP.AkimboSingleReload = false

SWEP.AutoAimAngle = math.cos(math.rad(30))
SWEP.AutoAimRange = 2000
SWEP.AutoAimSpeed = 35

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 5

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(-0.03, 0, -1)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, -3, 0)
SWEP.RecoilAngle = Angle(0, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.HoldType = "ar2"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeAim = "rpg"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleTexture = "effects/fire_cloud2"

SWEP.MuzzleOffset = Vector(-3.5, 22, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = "acxion/wep/aa12.ogg"
SWEP.ShootVolume = 110
SWEP.ShootPitch = 105

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/sg550/sg550_clipout.wav"
SWEP.ReloadHintSound = "weapons/sg552/sg552_clipin.wav"
SWEP.ReloadHintSoundDelay = -0.5
SWEP.ReloadFinishSound = "weapons/sg552/sg552_boltpull.wav"