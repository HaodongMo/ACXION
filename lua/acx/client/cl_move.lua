ACX.FastReloadChance = false
ACX.ReleasedReload = false

hook.Add("CreateMove", "ACX_CreateMove", function(cmd)
    local wpn = LocalPlayer():GetActiveWeapon()

    if !IsValid(wpn) then return end
    if !wpn.ACX then return end

    local buttons = cmd:GetButtons()

    local shouldreload = false

    if bit.band(buttons, IN_RELOAD) != 0 then
        if wpn:GetReloading() then
            if ACX.FastReloadChance and ACX.ReleasedReload then
                local reload_progress = CurTime() - wpn:GetReloadTime()

                if reload_progress >= wpn:GetMinimumReloadTime() and reload_progress <= wpn:GetMaximumFastReloadTime() then
                    shouldreload = true
                elseif reload_progress > 0.1 then
                    ACX.FastReloadChance = false
                end
            end
        else
            shouldreload = true
        end
    else
        ACX.ReleasedReload = true
    end

    if shouldreload then
        buttons = bit.bor(buttons, IN_RELOAD)
    else
        buttons = bit.band(buttons, bit.bnot(IN_RELOAD))
    end

    cmd:SetButtons(buttons)
end)