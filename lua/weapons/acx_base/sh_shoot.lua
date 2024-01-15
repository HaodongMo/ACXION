-- We use our own custom functions to handle these!
function SWEP:PrimaryAttack()
    if self:GetOwner():IsNPC() then
        self:NPC_PrimaryAttack()
        return
    end
end

function SWEP:SecondaryAttack()
end

local ammo_lookup = {
    ["buckshot"] = "acx_tracer_buckshot",
    ["357"] = "acx_tracer_sniper",
    ["pistol"] = "acx_tracer_pistol",
    ["smg1"] = "acx_tracer_smg",
}

function SWEP:GetTracerName()
    if self.TracerName != nil then
        return self.TracerName
    elseif ammo_lookup[self.Primary.Ammo] then
        return ammo_lookup[self.Primary.Ammo]
    end
    return "acx_tracer"
end

function SWEP:GetStillWaiting(left)
    if left then
        if self:GetNextSecondaryFire() > CurTime() then return true end
        if self:GetWait2Time() > CurTime() then return true end
        if self:GetReloading() and self:GetReloading2() then return true end
    else
        if self:GetNextPrimaryFire() > CurTime() then return true end
        if self:GetWaitTime() > CurTime() then return true end
        if self:GetReloading() and not self:GetReloading2() then return true end
    end

    return false
end

function SWEP:GetShootAngle(left)
    local ang

    if left then
        ang = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles() - self:GetLockAngle2()
    else
        ang = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles() - self:GetLockAngle()
    end

    return ang
end

function SWEP:GetHasHardLock(left)
    local pos = self:GetOwner():EyePos()
    local ang = self:GetShootAngle(left)
    local target

    if not left and IsValid(self:GetLockOnEntity()) then
        target = self:GetLockOnEntity()
    elseif left and IsValid(self:GetLockOnEntity2()) then
        target = self:GetLockOnEntity2()
    end

    if not target then return false end

    local targeting_tr = util.TraceLine({
        start = pos,
        endpos = pos + ang:Forward() * self.AutoAimRange * 2,
        filter = self:GetOwner(),
        mask = MASK_SHOT_HULL
    })

    return targeting_tr.Entity == target
end

function SWEP:GetShootPos(left)
    local pos = self:GetOwner():EyePos()

    if not self:GetAiming() and self.ProjectileEntity then
        if left then
            pos = pos + (self:GetOwner():GetRight() * -8)
        else
            pos = pos + (self:GetOwner():GetRight() * 8)
        end
    end

    return pos
end

function SWEP:Shoot(left)
    if self:GetStillWaiting(left) then return end

    if left then
        if self:GetNeedCycle2() then return end

        if self:Clip2() < self.AmmoPerShot then
            self:DryFire(true)

            return
        end
    else
        if self:GetNeedCycle() then return end

        if self:Clip1() < self.AmmoPerShot then
            self:DryFire()

            return
        end
    end

    local spread = self:GetSpread()
    local ang = self:GetShootAngle(left)
    local damage = self:GetDamage()

    -- "Lucky Last" - Last 10% of the magazine starts to ramp up damage up to 50% more
    if left then
        if self:Clip2() <= self.Primary.ClipSize * 0.1 then
            damage = damage + (damage * (0.5 * (1 - (self:Clip2() / (self.Primary.ClipSize * 0.1)))))
        end
    else
        if self:Clip1() <= self.Primary.ClipSize * 0.1 then
            damage = damage + (damage * (0.5 * (1 - (self:Clip1() / (self.Primary.ClipSize * 0.1)))))
        end
    end

    self:SetLastShotLeft(left)

    if self:GetProjectileEntity() then
        if SERVER then
            local shoot_entity = ents.Create(self:GetProjectileEntity())
            if not IsValid(shoot_entity) then return end
            local pos = self:GetShootPos(left)

            local shootentdata = {}

            if self.ProvideTargetData then
                if not left and IsValid(self:GetLockOnEntity()) then
                    shootentdata.Target = self:GetLockOnEntity()
                elseif left and IsValid(self:GetLockOnEntity2()) then
                    shootentdata.Target = self:GetLockOnEntity2()
                end

                if self.HardLockForTargetData then
                    if not self:GetHasHardLock(left) then
                        shootentdata.Target = nil
                    end
                end
            end

            ang = ang + AngleRand() / 360 * math.deg(spread)
            shoot_entity.ShootEntData = shootentdata
            shoot_entity:SetPos(pos)
            shoot_entity:SetAngles(ang)
            shoot_entity:SetOwner(self:GetOwner())
            shoot_entity:Spawn()
            shoot_entity:Activate()
            local phys = shoot_entity:GetPhysicsObject()

            if IsValid(phys) then
                phys:SetVelocity(ang:Forward() * self:GetProjectileForce() + self:GetOwner():GetVelocity())
            end
        end
    else
        ignore_entity = self:GetOwner():GetVehicle()

        local bullet = {
            Attacker = self:GetOwner(),
            Damage = damage,
            Force = damage / 3,
            Num = self:GetNum(),
            Tracer = self:GetTracerName() and 1 or 0,
            TracerName = self:GetTracerName(),
            Dir = ang:Forward(),
            Src = self:GetShootPos(),
            Spread = Vector(spread, spread, 0),
            Distance = 50000,
            IgnoreEntity = ignore_entity,
            Callback = function(attacker, tr, dmginfo)
                local dmg = dmginfo:GetDamage()

                if tr.HitGroup == HITGROUP_HEAD then
                    dmg = dmg * self:GetHeadshotMultiplier()
                end

                dmginfo:SetDamage(dmg)
            end
        }

        if IsFirstTimePredicted() then
            self:GetOwner():FireBullets(bullet)
        end
    end

    if IsFirstTimePredicted() then
        self:DoMuzzleEffects(left)
    end

    local recoil = self:GetRecoil()
    local punchAngle = Angle(util.SharedRandom("acx_recoil_left", -1, 1, self:GetOwner():GetCurrentCommand()) * recoil, util.SharedRandom("acx_recoil_up", -1, 1, self:GetOwner():GetCurrentCommand()) * recoil, 0.5 * math.Rand(-1, 1) * recoil)

    self:GetOwner():ViewPunch(punchAngle)

    if left then
        self:SetBurst2Count(self:GetBurst2Count() + 1)
    else
        self:SetBurstCount(self:GetBurstCount() + 1)
    end

    if left then
        self:TakeSecondaryAmmo(self.AmmoPerShot)
    else
        self:TakePrimaryAmmo(self.AmmoPerShot)
    end

    if left then
        self:SetNextSecondaryFire(CurTime() + (60 / self:GetRateOfFire()))
    else
        self:SetNextPrimaryFire(CurTime() + (60 / self:GetRateOfFire()))
    end

    if self:GetAkimbo() then
        if left then
            self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)
        else
            self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
        end
    else
        self:GetOwner():DoAnimationEvent(self.GestureShoot)
    end

    self:EmitSound(self.ShootSound, self.ShootVolume, self.ShootPitch + (math.Rand(-1, 1) * self.ShootPitchVariation), 1, CHAN_STATIC)

    if left then
        self:SetShot2Queued(false)
    else
        self:SetShotQueued(false)
    end

    if self.CycleBetweenShots then
        if left and self:Clip2() > 0 then
            self:SetNeedCycle2(true)
            self:SendNeedCycle2()
        elseif self:Clip1() > 0 then
            self:SetNeedCycle(true)
            self:SendNeedCycle()
        end
    end
end

function SWEP:DryFire(left)
    self:EmitSound(self.DryFireSound, 75, 100, 1, CHAN_ITEM)

    if left then
        self:SetShot2Queued(false)
        self:SetBurst2Count(0)
    else
        self:SetShotQueued(false)
        self:SetBurstCount(0)
    end
end

function SWEP:SendNeedCycle()
    if game.SinglePlayer() then
        self:CallOnClient("SendNeedCycle")
    end

    if not game.SinglePlayer() and not IsFirstTimePredicted() then return end

    ACX.CycleAmount = 0
end

function SWEP:SendNeedCycle2()
    if game.SinglePlayer() then
        self:CallOnClient("SendNeedCycle2")
    end

    if not game.SinglePlayer() and not IsFirstTimePredicted() then return end

    ACX.CycleAmount2 = 0
end

function SWEP:DoMuzzleEffects(left)
    if not IsFirstTimePredicted() then return end
    local data = EffectData()
    data:SetEntity(self)
    data:SetFlags(left and 1 or 0)
    util.Effect(self.MuzzleEffect, data)
end

function SWEP:FX_IsThirdPerson()
    local owner = self:GetOwner()
    if not IsValid(owner) then return true end
    if owner:IsNPC() then return true end

    return self:GetOwner():ShouldDrawLocalPlayer()
end

function SWEP:FX_GetShouldPos(left)
    if self:FX_IsThirdPerson() then
        local owner = self:GetOwner()
        local wpos, wang = self:GetPos(), self:GetAngles()

        if IsValid(owner) then
            local bone_name = "ValveBiped.Bip01_R_Hand"

            if left then
                bone_name = "ValveBiped.Bip01_L_Hand"
            end

            local boneid = self:GetOwner():LookupBone(bone_name)
            local bone_matrix = self:GetOwner():GetBoneMatrix(boneid)
            if not bone_matrix then return self:GetPos(), self:GetAngles() end
            wpos = bone_matrix:GetTranslation()
            wang = bone_matrix:GetAngles()
        end

        local pos, ang = self:GetCustomWorldPos(wpos, wang, left)
        pos = pos + ang:Right() * self.MuzzleOffset.x
        pos = pos + ang:Forward() * self.MuzzleOffset.y
        pos = pos + ang:Up() * self.MuzzleOffset.z

        return pos, ang
    else
        local vpos = self:GetOwner():EyePos()
        local vang = self:GetOwner():EyeAngles()
        local pos, ang = self:GetCustomViewPos(vpos, vang, left)
        pos = pos + ang:Right() * self.MuzzleOffset.x
        pos = pos + ang:Forward() * self.MuzzleOffset.y
        pos = pos + ang:Up() * self.MuzzleOffset.z

        return pos, ang
    end
end