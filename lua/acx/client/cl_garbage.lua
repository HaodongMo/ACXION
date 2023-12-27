ACX.CSModelPile    = {} -- { {Model = NULL, Weapon = NULL} }
ACX.EmitterPile    = {} -- { {Emitter = NULL, Weapon = NULL} }

function ACX.CollectGarbage()
    local removed = 0
    local kept = 0
    local newpile = {}

    for _, k in ipairs(ACX.CSModelPile) do
        if IsValid(k.Weapon) and k.Weapon:GetOwner() and k.Weapon:GetOwner():GetActiveWeapon() == k.Weapon then
            kept = kept + 1
            newpile[kept] = k
            continue
        end

        SafeRemoveEntity(k.Model)

        removed = removed + 1
    end

    ACX.CSModelPile = newpile

    local newemitterpile = {}
    local kept_emitters = 0

    for _, k in ipairs(ACX.EmitterPile) do
        if IsValid(k.Weapon) then
            newemitterpile[kept_emitters] = k
            kept_emitters = kept_emitters + 1
            continue
        end

        if IsValid(k.Emitter) then
            k.Emitter:Finish()
        end
    end

    // print("ACX: Garbage Collector removed " .. removed .. " CSModels and " .. kept .. " CSModels were kept.")

    ACX.EmitterPile = newemitterpile
end

hook.Add("PostCleanupMap", "ACX.CleanGarbage", function()
    ACX.CollectGarbage()
end)

timer.Create("ACX CSModel Garbage Collector", 5, 0, ACX.CollectGarbage)