function SWEP:NPC_PrimaryAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    local enemy = owner:GetEnemy()
    local aps = self.AmmoPerShot

    if self:Clip1() < aps then
        if not IsValid(enemy) or not IsValid(enemy:GetActiveWeapon()) or table.HasValue({"weapon_crowbar", "weapon_stunstick"}, enemy:GetActiveWeapon():GetClass()) then
            -- do not attempt to find cover if enemy does not have a ranged weapon
            self:GetOwner():SetSchedule(SCHED_RELOAD)
        else
            self:GetOwner():SetSchedule(SCHED_HIDE_AND_RELOAD)
        end

        return
    end

    self.Primary.Automatic = true

    self:EmitSound(self.ShootSound, self.ShootVolume, self.ShootPitch + (math.Rand(-1, 1) * self.ShootPitchVariation), 1, CHAN_STATIC)

    local delay = 60 / self.RateOfFire

    self:SetNextPrimaryFire(CurTime() + delay)

    if delay < 0.1 then
        self:GetOwner():NextThink(CurTime() + delay) -- they will only attempt to fire once per think
    end

    local spread = self:GetNPCSpread()
    local dir = self:GetOwner():GetAimVector()

    if self:GetProjectileEntity() then
        if IsValid(enemy) then
            dir = (enemy:WorldSpaceCenter() - self:GetOwner():GetShootPos()):GetNormalized():Angle()
            dir = dir + (math.deg(spread + (0.1 / self:GetOwner():GetCurrentWeaponProficiency())) * AngleRand() / 360)
        end

        local shoot_entity = ents.Create(self:GetProjectileEntity())
        if not IsValid(shoot_entity) then return end
        local pos = self:GetOwner():GetShootPos()

        local shootentdata = {}

        if self.ProvideTargetData then
            shootentdata.Target = enemy
        end

        shoot_entity.ShootEntData = shootentdata
        shoot_entity:SetPos(pos)
        shoot_entity:SetAngles(dir)
        shoot_entity:SetOwner(owner)
        shoot_entity:Spawn()
        shoot_entity:Activate()
        local phys = shoot_entity:GetPhysicsObject()

        if IsValid(phys) then
            phys:SetVelocity(dir:Forward() * self:GetProjectileForce() + owner:GetVelocity())
        end
    else
        local damage = self:GetDamage()

        damage = damage * 0.5

        self:GetOwner():FireBullets({
            Attacker = self:GetOwner(),
            Damage = damage,
            Force = damage / 3,
            Num = self:GetNum(),
            Tracer = 1,
            TracerName = "acx_tracer",
            Dir = dir,
            Src = self:GetShootPos(),
            Spread = Vector(spread, spread, 0),
            Distance = 50000,
            Callback = function(attacker, tr, dmginfo)
                local dmg = dmginfo:GetDamage()

                if tr.HitGroup == HITGROUP_HEAD then
                    dmg = dmg * self:GetHeadshotMultiplier()
                end

                dmginfo:SetDamage(dmg)
            end
        })
    end

    self:TakePrimaryAmmo(aps)

    self:DoMuzzleEffects()
end

function SWEP:GetNPCBulletSpread(prof)
    local mode = self.Firemode

    local is_auto = mode == "auto"
    local is_burst = not is_auto and string.Left(mode, 5) == "burst"
    local is_binary = not is_auto and not is_burst and mode == "binary"

    if is_burst or is_binary then
        return 10 / (prof + 1)
    elseif is_auto then
        if math.Rand(0, 100) < (prof + 5) * 2 then
            return 5 / (prof + 1)
        else
            return 30 / (prof + 1)
        end
    else
        if math.Rand(0, 100) < (prof + 5) * 5 then
            return 2 / (prof + 1)
        else
            return 20 / (prof + 1)
        end
    end

    return 15
end

function SWEP:GetNPCSpread()
    return self.Spread
end

function SWEP:GetNPCBurstSettings()
    local mode = self.Firemode
    local delay = 60 / self.RateOfFire

    local is_auto = mode == "auto"
    local is_burst = not is_auto and string.Left(mode, 5) == "burst"
    local is_binary = not is_auto and not is_burst and mode == "binary"

    if is_burst then
        local burst_length = tonumber(string.Right(mode, 1))
        return burst_length, burst_length, delay
    elseif is_auto then
        local c = self.Primary.ClipSize

        return math.ceil(c * 0.075), math.max(1, math.floor(c * math.Rand(0.15, 0.3))), delay + math.Rand(0.1, 0.2)
    elseif is_binary then
        return 2, 4, delay
    else
        return 1, 1, delay
    end
end

function SWEP:GetNPCRestTimes()
    local mode = self.Firemode
    local postburst = self.BurstDelay or 0
    local m = self.Recoil
    local delay = 60 / self.RateOfFire

    local is_auto = mode == "auto"
    local is_burst = not is_auto and string.Left(mode, 5) == "burst"
    local is_binary = not is_auto and not is_burst and mode == "binary"

    if is_auto then
        return delay + 0.4 * m, delay + 0.6 * m
    elseif is_burst then
        return delay + 0.4 * delay + 1 + postburst, delay + 0.6 * m
    elseif is_binary then
        return delay + 0.4 * delay + 1 + postburst, delay + 0.6 * m
    else
        return delay + 0.3 * m, delay + 0.6 * m
    end
end

function SWEP:CanBePickedUpByNPCs()
    return self.NPCUsable
end

function SWEP:NPC_Reload()
    self:SetClip1(self.Primary.ClipSize)

    self:EmitSound(self.ReloadStartSound, 75, 100, 1, CHAN_AUTO)

    timer.Simple(1, function()
        if IsValid(self) then
            self:EmitSound(self.ReloadHintSound, 75, 100, 1, CHAN_AUTO)
        end
    end)

    timer.Simple(1.5, function()
        if IsValid(self) then
            self:EmitSound(self.ReloadEndSound, 75, 100, 1, CHAN_AUTO)
        end
    end)
end

function SWEP:NPC_Initialize()
    if CLIENT then return end

    self:SetClip1(self.Primary.ClipSize)
end