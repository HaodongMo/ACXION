AddCSLuaFile()

SWEP.Base = "acx_base"
SWEP.Spawnable = true

SWEP.PrintName = "Model 700"
SWEP.Category = "ACXION"

-- Infobox
SWEP.Description = "The hunt is on."
SWEP.TypeName = "Sniper Rifle"

SWEP.Model = "models/tak/gtaiv/remington_m700.mdl"
SWEP.WorldModel = SWEP.Model
SWEP.Bodygroups = "000"

SWEP.ModelOffsetView = Vector(3, 7, -5.5)
SWEP.ModelAngleView = Angle(0, 0, 90)

SWEP.ModelOffsetWorld = Vector(1.5, 4, -1)
SWEP.ModelAngleWorld = Angle(5, 0, -90)

SWEP.Slot = 4

----------------- Stats

SWEP.Damage = 80
SWEP.Num = 1
SWEP.HeadshotMultiplier = 1
SWEP.Spread = 0.0035
SWEP.Recoil = 1.5
SWEP.RateOfFire = 600

SWEP.SpreadSightsMult = 0
SWEP.RecoilSightsMult = 0.25
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

SWEP.AutoAimAngle = math.cos(math.rad(1))
SWEP.AutoAimRange = 7500
SWEP.AutoAimSpeed = 5
SWEP.AutoAimSeek = "head"

SWEP.AutoAimOutOfSights = true
SWEP.AutoAimInSights = false

SWEP.CycleBetweenShots = true
SWEP.CycleDelay = 0.4

SWEP.Primary.Ammo = "357"
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.FastReloadBonus = 5

SWEP.Magnification = 4

SWEP.HasScope = true

SWEP.AimOffset = Vector(0, 0, 0)
SWEP.AimAngle = Angle(0, 0, 0)

SWEP.RecoilOffset = Vector(0, -3, 0)
SWEP.RecoilAngle = Angle(0, 0, 0)

----------------- Gestures

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.HoldType = "ar2"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeAim = "rpg"

SWEP.HolsterTime = 0.4

----------------- Effects

SWEP.MuzzleTexture = "effects/gunshipmuzzle"

SWEP.MuzzleOffset = Vector(-3.25, 32, 0)
SWEP.MuzzleAngle = Angle(0, 0, 0)
SWEP.MuzzleScale = 2

----------------- Sounds

SWEP.ShootSound = "acxion/wep/r700.ogg"
SWEP.ShootVolume = 110

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"

SWEP.ReloadStartSound = "acxion/wep/r700_r1.ogg"
SWEP.ReloadFinishSound = "acxion/wep/r700_bolt.ogg"

SWEP.CycleSound = "acxion/wep/r700_bolt.ogg"