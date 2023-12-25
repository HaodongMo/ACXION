local col = Color(255, 200, 0, 255)
local col2 = Color(255, 50, 50, 255)
local col_bg = Color(0, 0, 0, 100)
local scope_arc_mat = Material("sprites/scope_arc")

function SWEP:ScaleFOVByWidthRatio(fovDegrees, ratio)
    local halfAngleRadians = fovDegrees * (0.5 * math.pi / 180)
    local t = math.tan(halfAngleRadians)
    t = t * ratio
    local retDegrees = (180 / math.pi) * math.atan(t)

    return retDegrees * 2
end

function SWEP:WidescreenFix(target)
    return self:ScaleFOVByWidthRatio(target, ((ScrW and ScrW() or 4) / (ScrH and ScrH() or 3)) / (4 / 3))
end

SWEP.TrueFOV = 90

function SWEP:DrawHUD()
    local aim_angle = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles() - self.InterpolatedLockAngle
    local pos = self:GetOwner():GetShootPos() + aim_angle:Forward() * 15000
    local x, y = pos:ToScreen().x, pos:ToScreen().y
    local ss = ScreenScale(1)

    if self:ShouldAim() and self.HasScope then
        -- Draw sprites/scope_arc four times to create a full circle
        local s = math.min(ScrW(), ScrH()) / 2
        surface.SetDrawColor(0, 0, 0, 255)
        surface.SetMaterial(scope_arc_mat)
        surface.DrawTexturedRectUV(x, y, s, s, 0, 0, 1, 1)
        surface.DrawTexturedRectUV(x - s, y, s, s, 1, 0, 0, 1)
        surface.DrawTexturedRectUV(x - s, y - s, s, s, 1, 1, 0, 0)
        surface.DrawTexturedRectUV(x, y - s, s, s, 0, 1, 1, 0)
        -- Draw black rectangles to cover the rest of the screen
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, x - s, ScrH())
        surface.DrawRect(x + s, 0, ScrW() - x - s + 1, ScrH())
        surface.DrawRect(x - s, 0, s * 2, y - s)
        surface.DrawRect(x - s, y + s - 1, s * 2, ScrH() - y - s + 2)
        -- Draw two lines to act as a crosshair
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawLine(x - ScrW(), y, x + ScrW(), y)
        surface.DrawLine(x, y - ScrH(), x, y + ScrH())
        local text_ammo_r = tostring(self:Clip1())
        surface.SetFont("ACX_8")
        surface.SetTextPos(x + ss * 5, y + ss * 4)
        surface.SetTextColor(col)

        if self:Clip1() == 0 then
            surface.SetTextColor(col2)
        end

        surface.DrawText(text_ammo_r)
    else
        local crosshair_x = ScrW() / 2
        local crosshair_y = ScrH() / 2
        y = y + self.LowerAmountRight * ScrH()
        surface.SetDrawColor(col)

        if self:Clip1() == 0 then
            surface.SetDrawColor(col2)
        end

        render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
        surface.DrawRect(crosshair_x - 1, crosshair_y - 1, 3, 3)
        local trueFOV = self:WidescreenFix(self.TrueFOV)
        local crosshair_radius = (ScrH() / trueFOV) * math.deg(self.Spread) + ScreenScale(1)

        for i = 0, 15 do
            local angle = (i / 16) * math.pi * 2
            local x1 = x + math.cos(angle) * crosshair_radius
            local y1 = y + math.sin(angle) * crosshair_radius
            local x2 = x + math.cos(angle + (math.pi * 2 / 16)) * crosshair_radius
            local y2 = y + math.sin(angle + (math.pi * 2 / 16)) * crosshair_radius
            surface.DrawLine(x1, y1, x2, y2)
        end

        render.OverrideBlend(false, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
        local text_ammo_r = tostring(self:Clip1())
        surface.SetFont("ACX_8")
        surface.SetTextPos(x + crosshair_radius + ss * 4, y + ss * 4)
        surface.SetTextColor(col)

        if self:Clip1() == 0 then
            surface.SetTextColor(col2)
        end

        surface.DrawText(text_ammo_r)

        if self:GetAkimbo() then
            local text_r = "R"
            surface.SetFont("ACX_8")
            surface.SetTextPos(x + crosshair_radius + ss * 6, y - ss * 10)
            surface.DrawText(text_r)
            local aim_angle2 = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles() - self.InterpolatedLockAngle2
            local pos2 = self:GetOwner():GetShootPos() + aim_angle2:Forward() * 15000
            local xl, yl = pos2:ToScreen().x, pos2:ToScreen().y
            yl = yl + self.LowerAmountLeft * ScrH()
            surface.SetDrawColor(col)

            if self:Clip2() == 0 then
                surface.SetDrawColor(col2)
            end

            render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)

            for i = 0, 3 do
                local angle = (i / 4) * math.pi * 2
                local x1 = xl + math.cos(angle) * crosshair_radius
                local y1 = yl + math.sin(angle) * crosshair_radius
                local x2 = xl + math.cos(angle + (math.pi * 2 / 4)) * crosshair_radius
                local y2 = yl + math.sin(angle + (math.pi * 2 / 4)) * crosshair_radius
                surface.DrawLine(x1, y1, x2, y2)
            end

            render.OverrideBlend(false, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
            local text_ammo_l = tostring(self:Clip2())
            surface.SetFont("ACX_8")
            local text_ammo_w, text_ammo_h = surface.GetTextSize(text_ammo_l)
            surface.SetTextPos(xl - crosshair_radius - text_ammo_w - ss * 4, yl + ss * 4)
            surface.SetTextColor(col)

            if self:Clip2() == 0 then
                surface.SetTextColor(col2)
            end

            surface.DrawText(text_ammo_l)
            local text_l = "L"
            surface.SetFont("ACX_8")
            local text_l_w, _ = surface.GetTextSize(text_l)
            surface.SetTextPos(xl - text_l_w - crosshair_radius - ss * 6, yl - ss * 10)
            surface.DrawText(text_l)
        end
    end

    if self:GetReloading() then
        local reloadline_x = ScrW() * 3 / 4
        local col_fg = col

        if not ACX.FastReloadChance then
            col_fg = col2
        end

        render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
        -- surface.SetDrawColor(col_bg)
        -- surface.DrawRect(reloadline_x, 0, 16 * ss, ScrH())
        local max_reload_time = self:GetMaximumReloadTime()
        local fast_reload_start_time = self:GetMinimumReloadTime()
        local fast_reload_finish_time = self:GetMaximumFastReloadTime()
        local fast_reload_y = ScrH() * (1 - (fast_reload_start_time / max_reload_time))
        local fast_reload_h = ScrH() * ((fast_reload_finish_time - fast_reload_start_time) / max_reload_time) * 0.65 -- Give a little bit of visual leeway
        surface.SetDrawColor(col2)
        surface.DrawRect(reloadline_x, fast_reload_y - fast_reload_h, 16 * ss, fast_reload_h)
        surface.SetDrawColor(col_fg)
        surface.DrawRect(reloadline_x, 0, 0.5 * ss, ScrH())
        -- Draw reload progress
        local delta = (CurTime() - self:GetReloadTime()) / max_reload_time
        local reloadprogress_y = ScrH() * (1 - delta)
        surface.SetDrawColor(col_fg)
        surface.DrawRect(reloadline_x, reloadprogress_y, 16 * ss, 2 * ss)
        render.OverrideBlend(false, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
        local text_r = "RELOAD"
        surface.SetFont("ACX_8")
        local text_w = surface.GetTextSize(text_r)
        surface.SetTextPos(reloadline_x - text_w - 4 * ss, fast_reload_y - 16 * ss)
        surface.SetTextColor(col_fg)
        surface.DrawText(text_r)

        if not ACX.FastReloadChance then
            local text_r2 = "FAIL"
            surface.SetFont("ACX_8")
            local text2_w = surface.GetTextSize(text_r2)
            surface.SetTextPos(reloadline_x - text2_w - 4 * ss, fast_reload_y - 8 * ss)
            surface.SetTextColor(col_fg)
            surface.DrawText(text_r2)
        end
    end

    if self:GetAkimbo() then
        if self:GetNeedCycle2() and self:GetOwner():KeyDown(IN_ATTACK) then
            local reloadline_x = ScrW() * 2 / 5
            local col_fg = col
            render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
            surface.SetDrawColor(col_fg)
            surface.DrawRect(reloadline_x, 0, 0.5 * ss, ScrH())
            local reloadline_y = ScrH() * 3 / 4
            local reload_cycle_line_y = ACX.CycleAmount2 * ScrH() * 3 / 4
            surface.DrawRect(reloadline_x + 1 - 16 * ss, reload_cycle_line_y, 16 * ss - 1, reloadline_y - reload_cycle_line_y)
            render.OverrideBlend(false, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
            local text_r = "PULL DOWN"
            surface.SetFont("ACX_8")
            local text_w = surface.GetTextSize(text_r)
            surface.SetTextPos(reloadline_x - text_w - ss * 4, reloadline_y + ss * 2)
            surface.SetTextColor(col_fg)
            surface.DrawText(text_r)
        end

        if self:GetNeedCycle() and self:GetOwner():KeyDown(IN_ATTACK2) then
            local reloadline_x = ScrW() * 3 / 5
            local col_fg = col
            render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
            surface.SetDrawColor(col_fg)
            surface.DrawRect(reloadline_x, 0, 0.5 * ss, ScrH())
            local reloadline_y = ScrH() * 3 / 4
            local reload_cycle_line_y = ACX.CycleAmount * ScrH() * 3 / 4
            surface.DrawRect(reloadline_x + 1, reload_cycle_line_y, 16 * ss - 1, reloadline_y - reload_cycle_line_y)
            render.OverrideBlend(false, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
            local text_r = "PULL DOWN"
            surface.SetFont("ACX_8")
            surface.SetTextPos(reloadline_x + ss * 4, reloadline_y + ss * 2)
            surface.SetTextColor(col_fg)
            surface.DrawText(text_r)
        end
    else
        if self:GetNeedCycle() and self:GetOwner():KeyDown(IN_ATTACK) then
            local reloadline_x = ScrW() * 3 / 5
            local col_fg = col
            render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
            surface.SetDrawColor(col_fg)
            surface.DrawRect(reloadline_x, 0, 0.5 * ss, ScrH())
            local reloadline_y = ScrH() * 3 / 4
            local reload_cycle_line_y = ACX.CycleAmount * ScrH() * 3 / 4
            surface.DrawRect(reloadline_x + 1, reload_cycle_line_y, 16 * ss - 1, reloadline_y - reload_cycle_line_y)
            render.OverrideBlend(false, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
            local text_r = "PULL DOWN"
            surface.SetFont("ACX_8")
            surface.SetTextPos(reloadline_x + ss * 4, reloadline_y + ss * 2)
            surface.SetTextColor(col_fg)
            surface.DrawText(text_r)
        end
    end
end

function SWEP:AdjustMouseSensitivity()
    if self:ShouldAim() then return 1 / self.Magnification end
end

SWEP.Mat_Select = nil

function SWEP:DrawWeaponSelection(x, y, w, h, a)
    if not self.Mat_Select then
        self.Mat_Select = Material(self.IconOverride or "entities/" .. self:GetClass() .. ".png", "smooth mips")
    end

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(self.Mat_Select)

    if self.IconOverride then
        w = w - 128
        x = x + 64
    end

    if w > h then
        y = y - ((w - h) / 2)
    end

    surface.DrawTexturedRect(x, y, w, w)
end