AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "HK69A1"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "Explosions solve problems."
SWEP.TypeName = "Launcher"

SWEP.Model = "models/tak/gtaiv/hk69a1.mdl"

SWEP.ModelOffsetView = Vector(5, 13, -7)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 4

----------------- Stats

SWEP.Damage = 100

SWEP.ProjectileEntity = "acx_proj_40mm"

SWEP.Spread = 0.04
SWEP.Recoil = 1.5
SWEP.RateOfFire = 100

SWEP.SpreadSightsMult = 0.5
SWEP.RecoilSightsMult = 1
SWEP.AutoAimSpeedSightsMult = 1

SWEP.SpreadAkimboMult = 1.5
SWEP.RecoilAkimboMult = 1
SWEP.AutoAimSpeedAkimboMult = 0.75

SWEP.Firemode = "binary"
-- auto
-- semi
-- semi_falling
-- binary
-- pump
-- bolt
-- burst_3, burst_2

SWEP.ReloadTime = 0.5
SWEP.ReloadDifficultyMult = 1
SWEP.ShotgunReload = true
SWEP.AkimboSingleReload = false

SWEP.AutoAimAngle = math.cos(math.rad(30))
SWEP.AutoAimRange = 3500
SWEP.AutoAimSpeed = 60

SWEP.Primary.Ammo = "smg1_grenade"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 1

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

SWEP.MuzzleTexture = "effects/gunshipmuzzle"

SWEP.MuzzleOffset = Vector(-3.5, 16, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 1

----------------- Sounds

SWEP.ShootSound = "weapons/grenade_launcher1.wav"
SWEP.ShootVolume = 110

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "weapons/p90/p90_cliprelease.wav"
SWEP.ReloadFinishSound = "weapons/m3/m3_insertshell.wav"