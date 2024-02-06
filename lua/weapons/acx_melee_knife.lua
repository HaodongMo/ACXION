AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "Knife"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "Sharp and pointy."
SWEP.TypeName = "Bladed Weapon"

SWEP.Model = "models/tak/gtaiv/combat_knife.mdl"
SWEP.WorldModel = SWEP.Model
SWEP.Bodygroups = ""

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
SWEP.Recoil = 0
SWEP.RateOfFire = 60

SWEP.SpreadSightsMult = 0.5
SWEP.RecoilSightsMult = 0.5
SWEP.AutoAimSpeedSightsMult = 1

SWEP.SpreadAkimboMult = 3
SWEP.RecoilAkimboMult = 1.25
SWEP.AutoAimSpeedAkimboMult = 0.8

SWEP.Firemode = "melee"
-- auto
-- semi
-- semi_falling
-- binary
-- pump
-- bolt
-- burst_3, burst_2

SWEP.AutoAimAngle = math.cos(math.rad(20))
SWEP.AutoAimRange = 5000
SWEP.AutoAimSpeed = 20

SWEP.Primary.Ammo = ""
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0

SWEP.AmmoPerShot = 0

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(-0.25, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, 0.1, 0.02)
SWEP.RecoilAngle = Angle(math.rad(-90), 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.HoldType = "ar2"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeAim = "rpg"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleEffect = false

----------------- Sounds

SWEP.ShootSound = "weapons/knife/knife_slash1.wav"
SWEP.ShootVolume = 75

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/ak47/ak47_clipout.wav"
SWEP.ReloadFinishSound = "weapons/ak47/ak47_boltpull.wav"

SWEP.CanAkimbo = false