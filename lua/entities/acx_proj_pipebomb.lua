AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "acx_proj_base"
ENT.PrintName 			= "Pipe Bomb"

ENT.Spawnable 			= false
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE

ENT.Model = "models/tak/gtaiv/pipe_bomb.mdl"
ENT.Ticks = 0
ENT.FuseTime = 0
ENT.Defused = false
ENT.SphereSize = 1
ENT.PhysMat = "grenade"

ENT.Gravity = true

ENT.SmokeTrail = false

ENT.LifeTime = 6

ENT.Damage = 200
ENT.Radius = 400
ENT.ExplodeOnImpact = false

ENT.BounceSounds = {
    "weapons/hegrenade/he_bounce-1.wav",
}