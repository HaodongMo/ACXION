AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "acx_proj_base"
ENT.PrintName 			= "RPG-7 Rocket"

ENT.Spawnable 			= false
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE

ENT.Model = "models/Items/AR2_Grenade.mdl"
ENT.Ticks = 0
ENT.FuseTime = 0
ENT.Defused = false
ENT.SphereSize = 1
ENT.PhysMat = "grenade"

ENT.Gravity = false

ENT.SmokeTrail = true
ENT.SmokeTrailMat = "trails/smoke"
ENT.SmokeTrailSize = 32
ENT.SmokeTrailTime = 1

ENT.LifeTime = 20

ENT.Damage = 50
ENT.Radius = 328
ENT.ImpactDamage = 600
ENT.ExplodeOnImpact = true
ENT.Boost = 2500
ENT.Drunkenness = 0

ENT.Flare = true

ENT.SteerSpeed = 75 -- The maximum amount of degrees per second the missile can steer.
ENT.SeekerAngle = math.cos(35) -- The missile will lose tracking outside of this angle.
ENT.FireAndForget = true -- This missile automatically tracks its target.
ENT.NoReacquire = true
ENT.LeadTarget = true

ENT.HelicopterWorkaround = true