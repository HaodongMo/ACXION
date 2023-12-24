ACX.CSModelPile    = {} -- { {Model = NULL, Weapon = NULL} }

function ACX.CollectGarbage()
    local removed = 0
    local kept = 0
    local newpile = {}

    for _, k in ipairs(ACX.CSModelPile) do
        if IsValid(k.Weapon) then
            kept = kept + 1
            newpile[kept] = k
            continue
        end

        SafeRemoveEntity(k.Model)

        removed = removed + 1
    end

    ACX.CSModelPile = newpile
end

hook.Add("PostCleanupMap", "ACX.CleanGarbage", function()
    ACX.CollectGarbage()
end)

timer.Create("ACX CSModel Garbage Collector", 5, 0, ACX.CollectGarbage)