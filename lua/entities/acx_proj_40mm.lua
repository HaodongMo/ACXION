AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "acx_proj_base"
ENT.PrintName 			= "40mm Grenade"

ENT.Spawnable 			= false
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE

ENT.Model = "models/Items/AR2_Grenade.mdl"
ENT.Ticks = 0
ENT.FuseTime = 0
ENT.Defused = false
ENT.SphereSize = 1
ENT.PhysMat = "grenade"

ENT.Gravity = true

ENT.SmokeTrail = true
ENT.SmokeTrailMat = "effects/fas_smoke_beam"
ENT.SmokeTrailSize = 16
ENT.SmokeTrailTime = 1

ENT.LifeTime = 20

ENT.Damage = 45
ENT.Radius = 256
ENT.ImpactDamage = 25
ENT.ExplodeOnImpact = true