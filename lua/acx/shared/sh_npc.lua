hook.Add("InitPostEntity", "ACX_Register", function()
    for _, wpn in pairs(weapons.GetList()) do
        local tbl = weapons.Get(wpn.ClassName)

        if !tbl.ACX or !tbl.NPCUsable or !tbl.Spawnable then continue end

        list.Add("NPCUsableWeapons",
            {
                class = wpn.ClassName,
                title = wpn.PrintName
            }
        )
    end
end)

ACX.WeaponListCache = nil
function ACX.GetWeaponList()
    if !ACX.WeaponListCache then
        ACX.WeaponListCache = {}
        for i, wep in pairs(weapons.GetList()) do
            local weap = weapons.Get(wep.ClassName)
            if !weap or !weap.ACX
                    or wep.ClassName == "acx_base"
                    or !weap.Spawnable or weap.AdminOnly
                    or !weap.NPCUsable
                    then
                continue
            end

            table.insert(ACX.WeaponListCache, wep.ClassName)
        end
    end

    return ACX.WeaponListCache
end

function ACX.GetRandomWeapon()
    local tbl = ACX.GetWeaponList()
    PrintTable(tbl)
    return tbl[math.random(1, #tbl)]
end

if CLIENT then
    hook.Add("PopulateMenuBar", "ACX_NPCWeaponMenu", function (menubar)
        timer.Simple(0.1, function()
            local wpns = menubar:AddOrGetMenu("ACX NPC Weapons")

            wpns:AddCVar( "#menubar.npcs.defaultweapon", "gmod_npcweapon", "" )
            wpns:AddCVar( "#menubar.npcs.noweapon", "gmod_npcweapon", "none" )

            wpns:AddCVar("Random ACX Weapon", "gmod_npcweapon", "!ACXRandom")

            wpns:AddSpacer()

            wpns:SetDeleteSelf(false)

            local weaponlist = weapons.GetList()

            local catdict = {}
            local catnames = {}
            local catcontents = {}

            -- table.SortByMember(weaponlist, "PrintName", true)

            local cats = {}

            for _, k in pairs(weaponlist) do
                local weptbl = weapons.Get(k.ClassName)
                if weptbl and weptbl.ACX and weptbl.Spawnable
                        and weptbl.NPCUsable and !weptbl.PrimaryMelee and !weptbl.PrimaryGrenade then
                    local cat = k.Category or "Other"
                    if !catdict[cat] then
                        catdict[cat] = true
                        table.insert(catnames, cat)
                    end
                    catcontents[cat] = catcontents[cat] or {}
                    table.insert(catcontents[cat], {k.PrintName, k.ClassName})
                end
            end

            for _, cat in SortedPairsByValue(catnames) do
                cats[cat] = wpns:AddSubMenu(cat)
                cats[cat]:SetDeleteSelf(false)

                for _, info in SortedPairsByMemberValue(catcontents[cat], 1) do
                    cats[cat]:AddCVar(info[1], "gmod_npcweapon", info[2])
                end
            end
        end)
    end)

    net.Receive("ACX_npcweapon", function(len, ply)
        local class = GetConVar("gmod_npcweapon"):GetString()

        net.Start("ACX_npcweapon")
        net.WriteString(class)
        net.SendToServer()
    end)
elseif SERVER then
    hook.Add("PlayerSpawnedNPC", "ACX_NPCWeapon", function(ply, ent)
        net.Start("ACX_npcweapon")
        net.Send(ply)

        ply.ACX_LastSpawnedNPC = ent
    end)

    net.Receive("ACX_npcweapon", function(len, ply)
        local class = net.ReadString()
        local ent = ply.ACX_LastSpawnedNPC

        if !IsValid(ent) or !ent:IsNPC() or (class or "") == "" then return end

        local cap = ent:CapabilitiesGet()
        if bit.band(cap, CAP_USE_WEAPONS) != CAP_USE_WEAPONS then return end

        local wpn
        if class == "!ACXRandom" then
            class = ACX.GetRandomWeapon()
            wpn = weapons.Get(class or "")
            if !class or !wpn then return end
        else
            wpn = weapons.Get(class)
        end

        if !wpn or (wpn.AdminOnly and !ply:IsPlayer()) then return end

        if wpn.ACX and wpn.NPCUsable and wpn.Spawnable and (!wpn.AdminOnly or ply:IsAdmin()) then
            ent:Give(class)
        end
    end)
end
