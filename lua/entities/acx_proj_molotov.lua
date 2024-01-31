AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "acx_proj_base"
ENT.PrintName 			= "Molotov Cocktail"

ENT.Spawnable 			= false
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE

ENT.Model = "models/tak/gtaiv/molotov_coctail.mdl"
ENT.Ticks = 0
ENT.FuseTime = 0
ENT.Defused = false
ENT.SphereSize = 1
ENT.PhysMat = "grenade"

ENT.Gravity = true

ENT.SmokeTrail = true
ENT.SmokeTrailMat = "trails/smoke"
ENT.SmokeTrailSize = 16
ENT.SmokeTrailTime = 1

ENT.LifeTime = 3

ENT.Damage = 100
ENT.Radius = 256
ENT.ExplodeOnImpact = true

ENT.BounceSounds = {
    "weapons/hegrenade/he_bounce-1.wav",
}

ENT.Flare = true