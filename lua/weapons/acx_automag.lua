AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "Automag"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "Accurate and powerful."
SWEP.TypeName = "Pistol"

SWEP.Model = "models/tak/gtaiv/auto-mag_pistol.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.ModelOffsetView = Vector(5, 12, -5)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 1

----------------- Stats

SWEP.Damage = 35
SWEP.Num = 1
SWEP.HeadshotMultiplier = 2
SWEP.Spread = 0.015
SWEP.Recoil = 1.5
SWEP.RateOfFire = 300

SWEP.SpreadSightsMult = 0.25
SWEP.RecoilSightsMult = 0.5
SWEP.AutoAimSpeedSightsMult = 0.75

SWEP.SpreadAkimboMult = 2
SWEP.RecoilAkimboMult = 1.25
SWEP.AutoAimSpeedAkimboMult = 1

SWEP.Firemode = "semi"
-- auto
-- semi
-- semi_falling
-- binary
-- pump
-- bolt
-- burst_3, burst_2

SWEP.ReloadTime = 0.5
SWEP.ReloadDifficultyMult = 1
SWEP.ShotgunReload = false

SWEP.AutoAimAngle = math.cos(math.rad(45))
SWEP.AutoAimRange = 3500
SWEP.AutoAimSpeed = 45
SWEP.AutoAimSeek = "both"

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 5

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(-0.1, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, -4, 0)
SWEP.RecoilAngle = Angle(40, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_PISTOL

SWEP.HoldType = "pistol"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeAim = "revolver"

SWEP.HolsterTime = 0.2

----------------- Effects

SWEP.TracerName = "acx_tracer"

SWEP.MuzzleTexture = "effects/combinemuzzle2"

SWEP.MuzzleOffset = Vector(-2, 10, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 0.5

----------------- Sounds

SWEP.ShootSound = "acxion/wep/automag.ogg"
SWEP.ShootVolume = 110

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/deagle/de_clipout.wav"
SWEP.ReloadFinishSound = "weapons/deagle/de_clipin.wav"