AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "DSR-1"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "High caliber and high profile."
SWEP.TypeName = "Sniper Rifle"

SWEP.Model = "models/tak/gtaiv/dsr-1.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.Bodygroups = "000"

SWEP.ModelOffsetView = Vector(4, 9, -6.5)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 4

----------------- Stats

SWEP.Damage = 95
SWEP.Num = 1
SWEP.HeadshotMultiplier = 2
SWEP.Spread = 0.01
SWEP.Recoil = 3
SWEP.RateOfFire = 300

SWEP.SpreadSightsMult = 0
SWEP.RecoilSightsMult = 0.5
SWEP.AutoAimSpeedSightsMult = 1

SWEP.SpreadAkimboMult = 2
SWEP.RecoilAkimboMult = 1
SWEP.AutoAimSpeedAkimboMult = 1

SWEP.Firemode = "bolt"
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

SWEP.AutoAimAngle = math.cos(math.rad(5))
SWEP.AutoAimRange = 7500
SWEP.AutoAimSpeed = 5

SWEP.AutoAimOutOfSights = false
SWEP.AutoAimInSights = true

SWEP.CycleBetweenShots = true
SWEP.CycleDelay = 0.5

SWEP.Primary.Ammo = "357"
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 5

SWEP.Magnification = 6

SWEP.HasScope = true

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

SWEP.MuzzleTexture = "effects/gunshipmuzzle"

SWEP.MuzzleOffset = Vector(-3.25, 25 , 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 2.5

----------------- Sounds

SWEP.ShootSound = "acxion/wep/dsr1.ogg"
SWEP.ShootVolume = 110

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "acxion/wep/dsr1_r1.ogg"
SWEP.ReloadFinishSound = "acxion/wep/dsr1_bolt.ogg"

SWEP.CycleSound = "acxion/wep/dsr1_bolt.ogg"