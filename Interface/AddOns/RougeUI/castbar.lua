local _, RougeUI = ...
local strformat, max = string.format, math.max

local function PurpleKoolaid(statusbar)
    if (not statusbar or statusbar.disconnected) then
        return
    end

    local min, max = statusbar:GetMinMaxValues()
    if (max <= min) then
        return
    end

    local value = statusbar:GetValue()
    if ((value < min) or (value > max)) then
        return
    end

    value = (value - min) / (max - min)

    local startR, startG, startB = 0.7, 0.3, 1.0
    local endR, endG, endB = 0.49803921568, 0, 1.0

    local progress = value * value

    local r = startR + (endR - startR) * progress
    local g = startG + (endG - startG) * progress
    local b = startB + (endB - startB) * progress

    statusbar:SetStatusBarColor(r, g, b)
end

local function modstyle()
    local t = TargetFrameSpellBar
    t.timer = t:CreateFontString(nil, "OVERLAY")
    t.timer:SetFontObject("SystemFont_Shadow_Small")
    t.timer:SetShadowColor(0, 0, 0)
    t.timer:SetShadowOffset(1, -1)
    t.timer:SetPoint("RIGHT", t, -2.5, 0)
    t.update = .1

    t.Text:SetFontObject("Game11Font_o1")
    t:SetWidth(142)
    t:SetHeight(10)
    t.Border:SetHeight(50)
    t.Border:SetWidth(190)
    t.Border:ClearAllPoints()
    t.Border:SetPoint("TOPLEFT", t, "TOPLEFT", -24, 20)
    t.Icon:SetHeight(16)
    t.Icon:SetWidth(16)
    t.Icon:ClearAllPoints()
    t.Icon:SetPoint("RIGHT", t, "LEFT", -5, 0)
    t.Text:ClearAllPoints()
    t.Text:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 2, -5)
    t.Text:SetJustifyH("LEFT")
    t.Text:SetShadowOffset(0, 0)
    t.Spark:SetAlpha(0.7)
    t.Flash:SetHeight(50)
    t.Flash:SetWidth(190)
    t.Flash:SetPoint("TOPLEFT", t, "TOPLEFT", -24, 20)

    t.Border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Border-Small")
    t.Flash:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Flash-Small")

    if FocusFrame then
        local f = FocusFrameSpellBar
        f.timer = f:CreateFontString(nil, "OVERLAY")
        f.timer:SetFontObject("SystemFont_Shadow_Small")
        f.timer:SetShadowColor(0, 0, 0)
        f.timer:SetShadowOffset(1, -1)
        f.timer:SetPoint("RIGHT", f, -2.5, 0)
        f.update = .1

        f.Text:SetFontObject("Game11Font_o1")
        f:SetWidth(142)
        f:SetHeight(10)
        f.Border:SetHeight(50)
        f.Border:SetWidth(190)
        f.Border:ClearAllPoints()
        f.Border:SetPoint("TOPLEFT", f, "TOPLEFT", -24, 20)
        f.Icon:SetHeight(16)
        f.Icon:SetWidth(16)
        f.Icon:ClearAllPoints()
        f.Icon:SetPoint("RIGHT", f, "LEFT", -5, 0)
        f.Text:ClearAllPoints()
        f.Text:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 2, -5)
        f.Text:SetJustifyH("LEFT")
        f.Text:SetShadowOffset(0, 0)
        f.Spark:SetAlpha(0.7)
        f.Flash:SetHeight(50)
        f.Flash:SetWidth(190)
        f.Flash:SetPoint("TOPLEFT", f, "TOPLEFT", -24, 20)

        f.Border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Border-Small")
        f.Flash:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Flash-Small")
    end

    local cf = CastingBarFrame
    cf.Border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Border-Small")
    cf.Flash:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Flash-Small")
    cf.Spark:SetAlpha(0.7)
    cf.Spark:SetHeight(40)
    cf.timer = cf:CreateFontString(nil, "OVERLAY")
    cf.timer:SetFontObject("SystemFont_Shadow_Small")
    cf.timer:SetShadowColor(0, 0, 0)
    cf.timer:SetShadowOffset(1, -1)
    cf.timer:SetPoint("RIGHT", cf, -2.5, 0.3)
    cf.Text:SetFontObject("Game11Font_o1")
    cf.timer:SetScale(1.15)
    cf.update = .1
end

local cf = CastingBarFrame
cf.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
cf.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
cf.Spark:SetHeight(50)
cf.Text:ClearAllPoints()
cf.Text:SetPoint("CENTER", 0, 1)
cf.Border:SetWidth(cf.Border:GetWidth() + 4)
cf.Flash:SetWidth(cf.Flash:GetWidth() + 4)
cf.BorderShield:SetWidth(cf.BorderShield:GetWidth() + 4)
cf.Border:SetPoint("TOP", 0, 26)
cf.Flash:SetPoint("TOP", 0, 26)
cf.BorderShield:SetPoint("TOP", 0, 26)

local function TimerHook(self, elapsed)
    if not self.timer then
        return
    end

    self.update = (self.update or 0) - elapsed

    if self.update <= 0 then
        local remainingTime = 0

        if self.casting then
            remainingTime = max(self.maxValue - self.value, 0)
        elseif self.channeling then
            remainingTime = max(self.value, 0)
        end

        self.timer:SetText(strformat("%.1f", remainingTime))
        self.update = 0.1
    end
end

local function ClassColors(self)
    local _, class = UnitClass(self.unit)
    local c = RAID_CLASS_COLORS[class]
    local failed = self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED)
    if c and not self.casted then
        self.casted = true
        if self.BorderShield:IsShown() and not failed then
            self:SetStatusBarColor(0, 1, 0.6)
        elseif failed then
            self:SetStatusBarColor(1, 0, 0)
        else
            self:SetStatusBarColor(c.r, c.g, c.b)
        end
        self.casted = false
    end
end

local FR = CreateFrame("Frame")
FR:RegisterEvent("PLAYER_LOGIN")
FR:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        if RougeUI.db.CastTimer then
            modstyle()
            if FocusFrame then
                FocusFrameSpellBar:HookScript("OnUpdate", function(self, elapsed)
                    TimerHook(self, elapsed)
                    RougeUI.RougeUIF:GradientColour(self)
                    if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                        self:SetStatusBarColor(216/255, 31/255, 42/255)
                    end
                end)
            end
            TargetFrameSpellBar:HookScript("OnUpdate", function(self, elapsed)
                TimerHook(self, elapsed)
                RougeUI.RougeUIF:GradientColour(self)
                if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                    self:SetStatusBarColor(216/255, 31/255, 42/255)
                end
            end)
            CastingBarFrame:HookScript("OnUpdate", function(self, elapsed)
                TimerHook(self, elapsed)
                PurpleKoolaid(self)
                if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                    self:SetStatusBarColor(216/255, 31/255, 42/255)
                end
            end)
        end
    end
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)