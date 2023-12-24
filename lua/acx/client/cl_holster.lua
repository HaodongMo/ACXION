hook.Add("StartCommand", "ACX_Holster", function(ply, ucmd)
    local wep = ply:GetActiveWeapon()

    if IsValid(wep) and wep.ACX then
        if wep:GetHolsterTime() != 0 and wep:GetHolsterTime() <= CurTime() then
            if IsValid(wep:GetHolsterEntity()) then
                wep:SetHolsterTime(-1)
                ucmd:SelectWeapon(wep:GetHolsterEntity()) -- Call the final holster request
            end
        end
    end
end)