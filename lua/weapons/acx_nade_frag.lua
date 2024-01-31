AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "Frag Grenade"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "When in doubt, throw it out."
SWEP.TypeName = "Explosive"

SWEP.Model = "models/tak/gtaiv/hand_grenade.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.ModelOffsetView = Vector(6, 17, -3)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 4

----------------- Stats

SWEP.Damage = 100

SWEP.ProjectileEntity = "acx_proj_frag"
SWEP.ProjectileForce = 1000
SWEP.ProjectileAngle = Angle(0, 0, 90)

SWEP.Spread = 0.1
SWEP.Recoil = 0.1
SWEP.RateOfFire = 60

SWEP.SpreadSightsMult = 0.5
SWEP.RecoilSightsMult = 1
SWEP.AutoAimSpeedSightsMult = 1

SWEP.SpreadAkimboMult = 1.5
SWEP.RecoilAkimboMult = 1
SWEP.AutoAimSpeedAkimboMult = 0.75

SWEP.Firemode = "throwable"
-- auto
-- semi
-- semi_falling
-- binary
-- pump
-- bolt
-- burst_3, burst_2

SWEP.AutoAimAngle = 0
SWEP.AutoAimRange = 0
SWEP.AutoAimSpeed = 60

SWEP.Primary.Ammo = "grenade"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 3

SWEP.Magnification = 1.25

SWEP.HasScope = false
SWEP.ScopeOverlay = nil

SWEP.AimOffset = Vector(0, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, 0, -1)
SWEP.RecoilAngle = Angle(0, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_PISTOL

SWEP.HoldType = "grenade"
SWEP.HoldTypeAim = "grenade"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleEffect = false

SWEP.MuzzleOffset = Vector(0, 0, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = "weapons/slam/throw.wav"
SWEP.ShootVolume = 75

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "acxion/wep/hk69a1_r1.ogg"
SWEP.ReloadFinishSound = "acxion/wep/hk69a1_r2.ogg"

SWEP.IsGrenade = true

SWEP.CanAkimbo = false