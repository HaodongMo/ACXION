AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "M249 SAW"
SWEP.Category = "ACXION"

SWEP.Model = "models/tak/gtaiv/m249.mdl"
SWEP.Bodygroups = "000"

SWEP.ModelOffsetView = Vector(4, 9, -8)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 3

SWEP.Bodygroups = "0000"

SWEP.BulletBodygroups = {
    [1] = {1, 1}
}

----------------- Stats

SWEP.Damage = 20
SWEP.Num = 1
SWEP.HeadshotMultiplier = 1.5
SWEP.ArmorPiercing = 0.5
SWEP.Spread = 0.015
SWEP.Recoil = 0.65
SWEP.RateOfFire = 650

SWEP.Firemode = "auto"
-- auto
-- semi
-- semi_falling
-- binary
-- pump
-- bolt
-- burst_3, burst_2

SWEP.ReloadTime = 2
SWEP.ReloadDifficultyMult = 1.5
SWEP.ShotgunReload = false

SWEP.AutoAimAngle = math.cos(math.rad(20))
SWEP.AutoAimRange = 5000
SWEP.AutoAimSpeed = 15

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 50

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(0, 0, 0)
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

SWEP.MuzzleOffset = Vector(-3.75, 28, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = "weapons/m249/m249-1.wav"
SWEP.ShootVolume = 110

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/m249/m249_boxout.wav"
SWEP.ReloadHintSound = "weapons/m249/m249_boxin.wav"
SWEP.ReloadHintSoundDelay = -1
SWEP.ReloadFinishSound = "weapons/galil/galil_boltpull.wav"