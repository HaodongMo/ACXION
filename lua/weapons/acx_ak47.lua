AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "AK-47"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "Iconic Soviet rifle."
SWEP.TypeName = "Assault Rifle"

SWEP.Model = "models/tak/gtaiv/ak47.mdl"
SWEP.WorldModel = SWEP.Model
SWEP.Bodygroups = "000"

SWEP.ModelOffsetView = Vector(4.5, 9, -6.5)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 3

----------------- Stats

SWEP.Damage = 24
SWEP.Num = 1
SWEP.HeadshotMultiplier = 1.5
SWEP.Spread = 0.01
SWEP.Recoil = 0.8
SWEP.RateOfFire = 550

SWEP.SpreadSightsMult = 0.5
SWEP.RecoilSightsMult = 0.5
SWEP.AutoAimSpeedSightsMult = 1

SWEP.SpreadAkimboMult = 3
SWEP.RecoilAkimboMult = 1.25
SWEP.AutoAimSpeedAkimboMult = 0.8

SWEP.Firemode = "auto"
-- auto
-- semi
-- semi_falling
-- binary
-- pump
-- bolt
-- burst_3, burst_2

SWEP.ReloadTime = 0.75
SWEP.ReloadDifficultyMult = 1
SWEP.ShotgunReload = false
SWEP.AkimboSingleReload = false

SWEP.AutoAimAngle = math.cos(math.rad(20))
SWEP.AutoAimRange = 5000
SWEP.AutoAimSpeed = 20

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 5

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(-0.25, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, -3, 0)
SWEP.RecoilAngle = Angle(0, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.HoldType = "ar2"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeAim = "rpg"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleTexture = "effects/ar2_altfire1b"

SWEP.MuzzleOffset = Vector(-3, 24, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = "acxion/wep/ak47.ogg"
SWEP.ShootVolume = 110

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/ak47/ak47_clipout.wav"
SWEP.ReloadFinishSound = "weapons/ak47/ak47_boltpull.wav"