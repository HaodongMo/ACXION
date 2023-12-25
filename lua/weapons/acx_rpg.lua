AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "RPG-7"
SWEP.Category = "ACXION"

SWEP.Model = "models/tak/gtaiv/rpg-7.mdl"

SWEP.ModelOffsetView = Vector(7, 13, -7)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, -0.25, 0)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 4

SWEP.Bodygroups = "0000"

SWEP.BulletBodygroups = {
    [1] = {1, 1}
}

----------------- Stats

SWEP.ProjectileEntity = "acx_proj_rpg"

SWEP.Spread = 0.025
SWEP.Recoil = 1
SWEP.RateOfFire = 150

SWEP.Firemode = "semi"
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

SWEP.AutoAimAngle = math.cos(math.rad(10))
SWEP.AutoAimRange = 5000
SWEP.AutoAimSpeed = 15
SWEP.AutoAimInSights = true
SWEP.AutoAimOutOfSights = false

SWEP.Primary.Ammo = "rpg_round"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 0

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(0, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, -2, 0)
SWEP.RecoilAngle = Angle(0, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_PISTOL

SWEP.HoldType = "ar2"
SWEP.HoldTypeAim = "rpg"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleTexture = "effects/fire_cloud2"

SWEP.MuzzleOffset = Vector(-3, 15, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 2

----------------- Sounds

SWEP.ShootSound = "weapons/rpg/rocketfire1.wav"
SWEP.ShootVolume = 110

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/m249/m249_coverup.wav"
SWEP.ReloadFinishSound = "weapons/p90/p90_clipin.wav"