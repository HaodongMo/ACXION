
local sizes_to_make = {
    8
}

local function generatefonts()
    local font = "consolas"

    for _, i in pairs(sizes_to_make) do

        surface.CreateFont( "ACX_" .. tostring(i), {
            font = font,
            size = ScreenScale(i),
            weight = i < 16 and 650 or 600,
            antialias = true,
            additive = true,
            extended = true, -- Required for non-latin fonts
        } )

    end
end

surface.CreateFont( "ACX_HudSelectionTitle", {
    font = "Verdana",
    size = 20,
    weight = 700,
    antialias = true,
    extended = true, -- Required for non-latin fonts
})

surface.CreateFont( "ACX_HudSelectionDesc", {
    font = "Verdana",
    size = 14,
    weight = 700,
    antialias = true,
    extended = true, -- Required for non-latin fonts
})



generatefonts()

function ACX.Regen()
    generatefonts()
end

concommand.Add("ACX_font_reload", ACX.Regen)

hook.Add("OnScreenSizeChanged", "ACX.FontRegen", function(oldWidth, oldHeight)
    print("Warning: Resolution was changed. If ACX fonts are too small/big now, try type  ACX_font_reload  in console ")
    timer.Simple(5, ACX.Regen)
end)