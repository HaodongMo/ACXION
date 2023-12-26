AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "Striker-12"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "Big drum, big damage. Glacial reload."
SWEP.TypeName = "Shotgun"

SWEP.Model = "models/tak/gtaiv/armsel_striker.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.ModelOffsetView = Vector(5.5, 10, -5.5)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 2

----------------- Stats

SWEP.Damage = 12
SWEP.Num = 8
SWEP.HeadshotMultiplier = 1
SWEP.Spread = 0.08
SWEP.Recoil = 1
SWEP.RateOfFire = 300

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

SWEP.ReloadTime = 0.4
SWEP.ReloadDifficultyMult = 0.4
SWEP.ShotgunReload = true
SWEP.AkimboSingleReload = true

SWEP.AutoAimAngle = math.cos(math.rad(30))
SWEP.AutoAimRange = 3500
SWEP.AutoAimSpeed = 60

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 3

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(0, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, -4, 0)
SWEP.RecoilAngle = Angle(0, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.HoldType = "smg"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeAim = "rpg"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleTexture = "effects/fire_cloud2"

SWEP.MuzzleOffset = Vector(-2.25, 18, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = "weapons/xm1014/xm1014-1.wav"
SWEP.ShootVolume = 110
SWEP.ShootPitch = 95

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/p90/p90_clipout.wav"
SWEP.ReloadFinishSound = "weapons/m3/m3_insertshell.wav"