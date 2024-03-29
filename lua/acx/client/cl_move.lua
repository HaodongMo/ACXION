ACX.FastReloadChance = false
ACX.ReleasedReload = false

ACX.CycleAmount = 0
ACX.CycleAmount2 = 0

ACX.ShouldEndBullrushTime = 0

local lastviewangles = nil

local cycledifficulty = 4

hook.Add("CreateMove", "ACX_CreateMove", function(cmd)
    local wpn = LocalPlayer():GetActiveWeapon()

    if !IsValid(wpn) then return end
    if !wpn.ACX then return end

    local buttons = cmd:GetButtons()

    local shouldreload = false
    local shouldattack1 = false
    local shouldattack2 = false
    local shouldweapon1 = false
    local shouldweapon2 = false
    local shouldbullrush = false

    local shouldrestrictview = false

    if bit.band(buttons, IN_RELOAD) != 0 then
        if wpn:GetReloading() then
            if ACX.FastReloadChance and ACX.ReleasedReload and ACX.ConVars["dynamic_reload"]:GetBool() then
                local reload_progress = CurTime() - wpn:GetReloadTime() + wpn:GetPingOffsetScale()

                if reload_progress >= wpn:GetMinimumReloadTime() and reload_progress <= wpn:GetMaximumFastReloadTime() then
                    shouldreload = true
                elseif reload_progress > 0.1 then
                    ACX.FastReloadChance = false
                    wpn:EmitSound("buttons/button10.wav", 60, 80)
                end
            end
        else
            shouldreload = true
        end
    else
        ACX.ReleasedReload = true
    end

    local lockontarget = wpn.LockOnEntity
    local lockontarget2 = wpn.LockOnEntity2

    if lockontarget != wpn.LastLockOnEntity then
        ACX.ShouldEndBullrushTime = CurTime() + 0.1
    end

    if lockontarget2 != wpn.LastLockOnEntity2 then
        ACX.ShouldEndBullrushTime = CurTime() + 0.1
    end

    if ACX.ShouldEndBullrushTime > CurTime() then
        shouldbullrush = true
    end

    wpn.LastLockOnEntity = lockontarget
    wpn.LastLockOnEntity2 = lockontarget2

    if bit.band(buttons, IN_ATTACK) != 0 then
        shouldattack1 = true
        if ACX.ConVars["cycle"]:GetInt() == 2 then
            if wpn:GetAkimbo() then
                if wpn:GetNeedCycle2() then
                    shouldrestrictview = true
                end
            elseif wpn:GetNeedCycle() then
                shouldrestrictview = true
            end
        end
    end

    if bit.band(buttons, IN_ATTACK2) != 0 then
        shouldattack2 = true
        if ACX.ConVars["cycle"]:GetInt() == 2 and wpn:GetAkimbo() and wpn:GetNeedCycle() then
            shouldrestrictview = true
        end
    end

    if shouldrestrictview then
        local mouseY = cmd:GetMouseY()

        if mouseY > 0 then
            if wpn:GetAkimbo() then
                if shouldattack1 then
                    ACX.CycleAmount2 = ACX.CycleAmount2 + (mouseY / ScrH()) * cycledifficulty
                    ACX.CycleAmount2 = math.Clamp(ACX.CycleAmount2, 0, 1)
                end

                if shouldattack2 then
                    ACX.CycleAmount = ACX.CycleAmount + (mouseY / ScrH()) * cycledifficulty
                    ACX.CycleAmount = math.Clamp(ACX.CycleAmount, 0, 1)
                end
            else
                if shouldattack1 then
                    ACX.CycleAmount = ACX.CycleAmount + (mouseY / ScrH()) * cycledifficulty
                    ACX.CycleAmount = math.Clamp(ACX.CycleAmount, 0, 1)
                end
            end
        end

        cmd:SetMouseY(0)
        if lastviewangles then
            cmd:SetViewAngles(lastviewangles)
        end
    else
        lastviewangles = cmd:GetViewAngles()
    end

    if wpn:GetAkimbo() then
        if ACX.CycleAmount2 >= 1 then
            shouldweapon1 = true
        end

        if ACX.CycleAmount >= 1 then
            shouldweapon2 = true
        end
    else
        if ACX.CycleAmount >= 1 then
            shouldweapon1 = true
        end

        if ACX.CycleAmount2 >= 1 then
            shouldweapon2 = true
        end
    end

    if shouldreload then
        buttons = bit.bor(buttons, IN_RELOAD)
    else
        buttons = bit.band(buttons, bit.bnot(IN_RELOAD))
    end

    if shouldattack1 then
        buttons = bit.bor(buttons, IN_ATTACK)
    else
        buttons = bit.band(buttons, bit.bnot(IN_ATTACK))
    end

    if shouldattack2 then
        buttons = bit.bor(buttons, IN_ATTACK2)
    else
        buttons = bit.band(buttons, bit.bnot(IN_ATTACK2))
    end

    if shouldweapon1 then
        buttons = bit.bor(buttons, IN_WEAPON1)
    else
        buttons = bit.band(buttons, bit.bnot(IN_WEAPON1))
    end

    if shouldweapon2 then
        buttons = bit.bor(buttons, IN_WEAPON2)
    else
        buttons = bit.band(buttons, bit.bnot(IN_WEAPON2))
    end

    if shouldbullrush then
        buttons = bit.bor(buttons, IN_BULLRUSH)
    else
        buttons = bit.band(buttons, bit.bnot(IN_BULLRUSH))
    end

    cmd:SetButtons(buttons)
end)