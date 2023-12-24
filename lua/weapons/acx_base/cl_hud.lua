local col = Color(255, 200, 0, 255)
local col2 = Color(255, 50, 50, 255)
local col_bg = Color(0, 0, 0, 100)
local scope_arc_mat = Material("sprites/scope_arc")

function SWEP:DrawHUD()
    if self:ShouldAim() and self.HasScope then
        local aim_angle = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles() - self.InterpolatedLockAngle

        local pos = self:GetOwner():GetShootPos() + aim_angle:Forward() * 15000

        local x, y = pos:ToScreen().x, pos:ToScreen().y

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
    end

    if self:GetReloading() then
        local ss = ScreenScale(1)
        local reloadline_x = ScrW() * 3 / 4
        local col_fg = col

        if not ACX.FastReloadChance then
            col_fg = col2
        end

        surface.SetDrawColor(col_bg)
        surface.DrawRect(reloadline_x, 0, 16 * ss, ScrH())
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
    end
end

function SWEP:AdjustMouseSensitivity()
    if self:ShouldAim() then return 1 / self.Magnification end
end