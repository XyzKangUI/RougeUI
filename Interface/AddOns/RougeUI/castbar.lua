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

local function modstyle(frame)
    local t = frame
    local selfName = frame:GetName()
    local Border = _G[selfName .. "Border"]
    local Icon = _G[selfName .. "Icon"]
    local Text = _G[selfName .. "Text"]
    local Spark = _G[selfName .. "Spark"]
    local Flash = _G[selfName .. "Flash"]
    local BorderShield = _G[selfName .. "BorderShield"]

    if frame == CastingBarFrame then
        Border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Border-Small")
        Flash:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Flash-Small")
        Spark:SetAlpha(0.7)
        Spark:SetHeight(40)
        Text:SetFontObject("SystemFont_Outline_Small")
        frame.timer = frame:CreateFontString(nil, "OVERLAY")
        frame.timer:SetFontObject("SystemFont_Shadow_Small")
        frame.timer:SetShadowColor(0, 0, 0)
        frame.timer:SetShadowOffset(1, -1)
        frame.timer:SetPoint("RIGHT", frame, -2.5, 0.3)
        frame.update = .1
        return
    end

    t.timer = t:CreateFontString(nil, "OVERLAY")
    t.timer:SetFontObject("SystemFont_Shadow_Small")
    t.timer:SetShadowColor(0, 0, 0)
    t.timer:SetShadowOffset(1, -1)
    t.timer:SetPoint("RIGHT", t, -2.5, 0)
    t.update = .1

    Text:SetFontObject("SystemFont_Outline_Small")
    t:SetWidth(142)
    t:SetHeight(10)
    Border:SetHeight(50)
    Border:SetWidth(190)
    Border:ClearAllPoints()
    Border:SetPoint("TOPLEFT", t, "TOPLEFT", -24, 20)
    Icon:SetHeight(16)
    Icon:SetWidth(16)
    Icon:ClearAllPoints()
    Icon:SetPoint("RIGHT", t, "LEFT", -5, 0)
    Text:ClearAllPoints()
    Text:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 2, -5)
    Text:SetJustifyH("LEFT")
    Text:SetShadowOffset(0, 0)
    Spark:SetAlpha(0.7)
    Flash:SetHeight(50)
    Flash:SetWidth(190)
    Flash:SetPoint("TOPLEFT", t, "TOPLEFT", -24, 20)
    BorderShield:ClearAllPoints()
    BorderShield:SetPoint("TOP", frame, -2, 20)

    Border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Border-Small.blp")
    Flash:SetTexture("Interface\\AddOns\\RougeUI\\textures\\UI-CastingBar-Flash-Small.blp")
end

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

local Border = CastingBarFrameBorder
local BorderShield = CastingBarFrameBorderShield
local Text = CastingBarFrameText
local Spark = CastingBarFrameSpark
local Flash = CastingBarFrameFlash
Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
Spark:SetHeight(50)
Text:ClearAllPoints()
Text:SetPoint("CENTER", 0, 1)
Border:SetWidth(Border:GetWidth() + 4)
Flash:SetWidth(Flash:GetWidth() + 4)
BorderShield:SetWidth(BorderShield:GetWidth() + 4)
Border:SetPoint("TOP", 0, 26)
Flash:SetPoint("TOP", 0, 26)
BorderShield:SetPoint("TOP", 0, 26)

local FR = CreateFrame("Frame")
FR:RegisterEvent("PLAYER_LOGIN")
FR:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        if RougeUI.db.CastTimer then
            C_Timer.After(5, function()
                modstyle(TargetFrameSpellBar)
                modstyle(FocusFrameSpellBar)
                modstyle(CastingBarFrame)
            end)
            if FocusFrame then
                FocusFrameSpellBar:HookScript("OnUpdate", function(self, elapsed)
                    TimerHook(self, elapsed)
                    RougeUI.RougeUIF:GradientColour(self)
                    if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                        self:SetStatusBarColor(216 / 255, 31 / 255, 42 / 255)
                    end
                end)
            end
            TargetFrameSpellBar:HookScript("OnUpdate", function(self, elapsed)
                TimerHook(self, elapsed)
                RougeUI.RougeUIF:GradientColour(self)
                if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                    self:SetStatusBarColor(216 / 255, 31 / 255, 42 / 255)
                end
            end)
            CastingBarFrame:HookScript("OnUpdate", function(self, elapsed)
                TimerHook(self, elapsed)
                PurpleKoolaid(self)
                if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                    self:SetStatusBarColor(216 / 255, 31 / 255, 42 / 255)
                end
            end)
        end
    end
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)