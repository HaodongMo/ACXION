AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "acx_proj_base"
ENT.PrintName 			= "Frag Grenade"

ENT.Spawnable 			= false
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE

ENT.Model = "models/tak/gtaiv/hand_grenade.mdl"
ENT.Ticks = 0
ENT.FuseTime = 0
ENT.Defused = false
ENT.SphereSize = 1
ENT.PhysMat = "grenade"

ENT.Gravity = true

ENT.SmokeTrail = false

ENT.LifeTime = 3

ENT.Damage = 100
ENT.Radius = 256
ENT.ExplodeOnImpact = false

ENT.BounceSounds = {
    "weapons/hegrenade/he_bounce-1.wav",
}