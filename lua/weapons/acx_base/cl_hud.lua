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
    local pos = self:GetShootPos(false) + aim_angle:Forward() * 15000
    cam.Start3D(nil, nil, self:WidescreenFix(self.TrueFOV))
    local x, y = pos:ToScreen().x, pos:ToScreen().y
    cam.End3D()
    local ss = ScreenScale(1)

    local clip_r = self:Clip1()
    local clip_l = self:Clip2()

    if self.Primary.ClipSize <= 0 then
        clip_r = self:Ammo1()
        clip_l = self:Ammo2()
    end

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

        -- Draw dot in the middle
        surface.SetDrawColor(col)
        surface.DrawRect(x, y - 1, 3, 3)

        local text_ammo_r = tostring(clip_r)
        surface.SetFont("ACX_8")
        surface.SetTextPos(x + ss * 5, y + ss * 4)
        surface.SetTextColor(col)

        if self:GetNeedCycle() then
            text_ammo_r = string.upper(self.Firemode)
            surface.SetTextColor(col2)
        elseif clip_r == 0 then
            surface.SetTextColor(col2)
        end

        surface.DrawText(text_ammo_r)
    else
        y = y + self.LowerAmountRight * ScrH()
        surface.SetDrawColor(col)

        if clip_r == 0 then
            surface.SetDrawColor(col2)
        end

        local hardlock_l = false
        local hardlock_r = false

        if self.HardLockForTargetData then
            if clip_l > 0 then
                hardlock_l = self:GetHasHardLock(true)
            end
            if clip_r > 0 then
                hardlock_r = self:GetHasHardLock(false)
            end
        end

        render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
        // surface.DrawRect(crosshair_x - 1, crosshair_y - 1, 3, 3)
        local trueFOV = self:WidescreenFix(self.TrueFOV)
        local crosshair_radius = (ScrH() / trueFOV) * math.deg(self:GetSpread()) + ScreenScale(1)

        for i = 0, 15 do
            local angle = (i / 16) * math.pi * 2
            local x1 = x + math.cos(angle) * crosshair_radius
            local y1 = y + math.sin(angle) * crosshair_radius
            local x2 = x + math.cos(angle + (math.pi * 2 / 16)) * crosshair_radius
            local y2 = y + math.sin(angle + (math.pi * 2 / 16)) * crosshair_radius
            surface.DrawLine(x1, y1, x2, y2)
        end

        if hardlock_r then
            local x1 = x - crosshair_radius
            local y1 = y - crosshair_radius
            local x2 = x + crosshair_radius
            local y2 = y + crosshair_radius

            surface.DrawLine(x, y1, x, y2)
            surface.DrawLine(x1, y, x2, y)
        end

        render.OverrideBlend(false, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
        local text_ammo_r = tostring(clip_r)
        surface.SetFont("ACX_8")
        surface.SetTextPos(x + crosshair_radius + ss * 4, y + ss * 4)
        surface.SetTextColor(col)

        if self:GetNeedCycle() then
            text_ammo_r = string.upper(self.Firemode)
            surface.SetTextColor(col2)
        elseif clip_r == 0 then
            surface.SetTextColor(col2)
        end

        surface.DrawText(text_ammo_r)

        local text_r = ""

        if self:GetAkimbo() then
            text_r = "R"
        end

        if IsValid(self:GetLockOnEntity()) then
            text_r = "R-TRK"
        end

        if hardlock_r then
            if math.sin(CurTime() * 10) > 0 then
                text_r = "SHOOT"
            end
        end

        surface.SetFont("ACX_8")
        surface.SetTextPos(x + crosshair_radius + ss * 6, y - ss * 10)
        surface.DrawText(text_r)

        if self:GetAkimbo() then
            local aim_angle2 = self:GetOwner():EyeAngles() - self:GetOwner():GetViewPunchAngles() - self.InterpolatedLockAngle2
            local pos2 = self:GetShootPos(true) + aim_angle2:Forward() * 15000
            local xl, yl = pos2:ToScreen().x, pos2:ToScreen().y
            yl = yl + self.LowerAmountLeft * ScrH()
            surface.SetDrawColor(col)

            if clip_l == 0 then
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

            if hardlock_l then
                local x1 = xl - crosshair_radius
                local y1 = yl - crosshair_radius
                local x2 = xl + crosshair_radius
                local y2 = yl + crosshair_radius

                surface.DrawLine(xl, y1, xl, y2)
                surface.DrawLine(x1, yl, x2, yl)
            end

            render.OverrideBlend(false, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
            local text_ammo_l = tostring(clip_l)
            if self:GetNeedCycle2() then
                text_ammo_l = string.upper(self.Firemode)
                surface.SetTextColor(col2)
            elseif clip_l == 0 then
                surface.SetTextColor(col2)
            else
                surface.SetTextColor(col)
            end

            surface.SetFont("ACX_8")
            local text_ammo_w, text_ammo_h = surface.GetTextSize(text_ammo_l)
            surface.SetTextPos(xl - crosshair_radius - text_ammo_w - ss * 4, yl + ss * 4)

            surface.DrawText(text_ammo_l)
            local text_l = "L"

            if IsValid(self:GetLockOnEntity2()) then
                text_l = "L-TRK"
            end

            if hardlock_l then
                if math.sin(CurTime() * 10) > 0 then
                    text_l = "SHOOT"
                end
            end

            surface.SetFont("ACX_8")
            local text_l_w, _ = surface.GetTextSize(text_l)
            surface.SetTextPos(xl - text_l_w - crosshair_radius - ss * 6, yl - ss * 10)
            surface.DrawText(text_l)
        end
    end

    if self:GetReloading() and ACX.ConVars["dynamic_reload"]:GetBool() then
        local reload_hint_text = "PRESS [" .. string.upper(input.LookupBinding("+reload") or "") .. "]"

        local reloadline_x = ScrW() * 3 / 4
        if self:GetReloading2() then
            reloadline_x = ScrW() * 1 / 4
        end
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
        local delta = (CurTime() - self:GetReloadTime() + self:GetPingOffsetScale()) / max_reload_time
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

        local text_r2 = reload_hint_text

        if not ACX.FastReloadChance then
            text_r2 = "FAIL"
        end

        surface.SetFont("ACX_8")
            local text2_w = surface.GetTextSize(text_r2)
            surface.SetTextPos(reloadline_x - text2_w - 4 * ss, fast_reload_y - 8 * ss)
            surface.SetTextColor(col_fg)
            surface.DrawText(text_r2)
    end

    if ACX.ConVars["cycle"]:GetInt() == 2 then
        if self:GetAkimbo() then
            if ACX.ConVars["cycle"]:GetInt() == 2 and  self:GetNeedCycle2() and self:GetOwner():KeyDown(IN_ATTACK) then
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

    self:PrintWeaponInfo(x + w + 20, y + h * 0.95, a)
end

function SWEP:CustomAmmoDisplay()
    self.AmmoDisplay = self.AmmoDisplay or {}
    self.AmmoDisplay.Draw = true

    if self:GetAkimbo() then
        self.AmmoDisplay.SecondaryAmmo = self:Clip2()
    else
        self.AmmoDisplay.SecondaryAmmo = -1
    end
    self.AmmoDisplay.PrimaryClip = self:Clip1()
    self.AmmoDisplay.PrimaryAmmo = self:Ammo1()

    if self.Primary.ClipSize < 0 then
        self.AmmoDisplay.PrimaryClip = self:Ammo1()
        self.AmmoDisplay.PrimaryAmmo = nil
    end

    return self.AmmoDisplay
end

local function boxes(f)
    local str = ""
    local boxc = math.Round(f * 10)
    for i = 1, 10 do
        if i <= boxc then
            str = str .. "■"
        else
            str = str .. "□"
        end
    end
    return str
end

SWEP.InfoMarkup = nil
function SWEP:PrintWeaponInfo(x, y, alpha)
    if self.DrawWeaponInfoBox == false then return end

    self.InfoMarkup = nil
    if self.InfoMarkup == nil then
        local str
        local title_color = "<color=230,230,230,255>"
        local text_color = "<color=150,150,150,255>"
        str = ""

        str = str .. "<font=ACX_HudSelectionTitle>" .. title_color .. self:GetFiremodeName() .. " " .. self.TypeName .. "</color></font>\n"

        if self.Description ~= "" then
            str = str .. "<font=ACX_HudSelectionDesc>" .. text_color .. self.Description .. "</color></font>\n"
        end

        str = str .. "\n<font=HudSelectionText>"

        str = str .. title_color .. "Ammo:</color>\t" .. text_color .. language.GetPhrase(self.Primary.Ammo .. "_ammo") .. "</color>\n"

        str = str .. title_color .. "Damage:</color>\t" .. text_color .. self.Damage .. (self.Num > 1 and ("x" .. self.Num) or "") .. "</color>\n"

        if self.CycleBetweenShots then
            local rpm = math.Round(6 / (60 / self.RateOfFire + self.CycleDelay)) * 10
            str = str .. title_color .. "Fire Rate:</color>\t" .. text_color .. "~" .. rpm .. " RPM</color>\n"
        else
            str = str .. title_color .. "Fire Rate:</color>\t" .. text_color .. self.RateOfFire .. " RPM</color>\n"
        end

        if self.Primary.ClipSize > 0 then
            local bonus = self.FastReloadBonus

            if not ACX.ConVars["dynamic_reload"]:GetBool() or not ACX.ConVars["reload_bonus"]:GetBool() then
                bonus = 0
            end

            str = str .. title_color .. "Capacity:</color>\t" .. text_color .. self.Primary.ClipSize .. (bonus > 0 and " (+" .. bonus .. ")" or "") .. "</color>\n"
        end

        local d
        if self.Num > 1 then
            str = str .. title_color .. "Spread:</color>\t" .. text_color
            d = Lerp(self.Spread / 0.125, 0, 1)
        else
            str = str .. title_color .. "Accuracy:</color>\t" .. text_color
            d = Lerp(math.log(1 + (self.Spread * self.SpreadSightsMult) / 0.03), 1, 0)
        end
        str = str .. boxes(d) .. "</color>\n"

        if self.CanAkimbo and self.SpreadAkimboMult ~= 1 then
            if self.Num > 1 then
                d = Lerp(self.Spread * self.SpreadAkimboMult / 0.125, 0, 1)
            else
                d = Lerp(math.log(1 + (self.Spread * self.SpreadAkimboMult) / 0.03), 1, 0)
            end
            str = str .. title_color .. "  - Akimbo:</color>\t" .. text_color
            str = str .. boxes(d) .. "</color>\n"
        end

        str = str .. title_color .. "Recoil:</color>\t" .. text_color
        str = str .. boxes(Lerp((math.abs(self.Recoil) ^ 0.5) / 2, 0, 1)) .. "</color>\n"

        if self.CanAkimbo and self.RecoilAkimboMult ~= 1 then
            str = str .. title_color .. "  - Akimbo:</color>\t" .. text_color
            str = str .. boxes(Lerp((math.abs(self.Recoil * self.RecoilAkimboMult) ^ 0.5) / 2, 0, 1)) .. "</color>\n"
        end

        str = str .. "</font>"
        self.InfoMarkup = markup.Parse(str, 250)
    end

    surface.SetDrawColor(60, 60, 60, alpha)
    surface.SetTexture(self.SpeechBubbleLid)
    surface.DrawTexturedRect(x, y - 64 - 5, 128, 64)
    draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(60, 60, 60, alpha))
    self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end