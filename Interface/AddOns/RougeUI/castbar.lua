local _, RougeUI = ...
local _G = getfenv(0)
local UnitCastingInfo = _G.UnitCastingInfo
local UnitChannelInfo = _G.UnitChannelInfo

local function modstyle()
    local t = TargetFrameSpellBar
    t.timer = t:CreateFontString(nil, "OVERLAY")
    t.timer:SetFontObject("SystemFont_Shadow_Small")
    t.timer:SetShadowColor(0, 0, 0)
    t.timer:SetShadowOffset(1, -1)
    t.timer:SetPoint("RIGHT", t, -3, 0)
    t.update = .1

    local f = FocusFrameSpellBar
    f.timer = f:CreateFontString(nil, "OVERLAY")
    f.timer:SetFontObject("SystemFont_Shadow_Small")
    f.timer:SetShadowColor(0, 0, 0)
    f.timer:SetShadowOffset(1, -1)
    f.timer:SetPoint("RIGHT", f, -3, 0)
    f.update = .1

    t.Text:SetFontObject("SystemFont_Outline_Small")
    t:ClearAllPoints()
    t:SetWidth(142)
    t:SetHeight(10)
    -- t.Text:SetPoint("TOP", t, 0, 4)
    t.Icon:Show()
    t.Icon:SetHeight(21)
    t.Icon:SetWidth(21)
    t.Icon:SetPoint("RIGHT", t, "LEFT", -10, 1)
    t.Text:ClearAllPoints()
    t.Text:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 2, -5)
    t.Text:SetJustifyH("LEFT")

    f.Text:SetFontObject("SystemFont_Outline_Small")
    f:ClearAllPoints()
    f:SetWidth(142)
    f:SetHeight(10)
    f.Text:SetPoint("TOP", f, 0, 4)
    f.Icon:Show()
    f.Icon:SetHeight(21)
    f.Icon:SetWidth(21)
    f.Icon:SetPoint("RIGHT", f, "LEFT", -10, 1)
    f.Text:ClearAllPoints()
    f.Text:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 2, -5)
    f.Text:SetJustifyH("LEFT")
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

local function c_OnUpdate_Hook(self, elapsed)
    if not self.timer then
        return
    end
    if self.update and self.update < elapsed then
        if self.casting then
            self.timer:SetText(string.format("%.1f", math.max(self.maxValue - self.value, 0)))
        elseif self.channeling then
            self.timer:SetText(string.format("%.1f", math.max(self.value, 0)))
        else
            self.timer:SetText("")
        end
        self.update = .1
    else
        self.update = self.update - elapsed
    end
end

local function RedBars(frame)
    if frame.Text:GetText() == INTERRUPTED or frame.Text:GetText() == FAILED then
        frame:SetStatusBarColor(1, 0, 0)
    end
end

local FR = CreateFrame("Frame")
FR:RegisterEvent("PLAYER_LOGIN")
FR:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        if RougeUI.db.CastTimer then
            modstyle()
            FocusFrameSpellBar:HookScript("OnUpdate", function(self, elapsed)
                c_OnUpdate_Hook(self, elapsed)
                RougeUI.RougeUIF:GradientColour(self, FocusFrameSpellBar)
                RedBars(self)
            end)
            TargetFrameSpellBar:HookScript("OnUpdate", function(self, elapsed)
                c_OnUpdate_Hook(self, elapsed)
                RougeUI.RougeUIF:GradientColour(self, TargetFrameSpellBar)
                RedBars(self)
            end)
            CastingBarFrame:HookScript("OnUpdate", function(self)
                RougeUI.RougeUIF:GradientColour(self, CastingBarFrame)
                RedBars(self)
            end)
            hooksecurefunc("CastingBarFrame_OnEvent", function(self, event, ...)
                local arg1 = ...
                local unit = self.unit;
                local name, text

                if self:IsForbidden() or not (self == TargetFrameSpellBar or self == FocusFrameSpellBar) or arg1 ~= unit then
                    return
                end

                if event == "UNIT_SPELLCAST_START" then
                    name, text = UnitCastingInfo(unit)
                elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                    name, text = UnitChannelInfo(unit)
                else
                    return
                end

                if self.BorderShield:IsShown() and name then
                    self.BorderShield:Hide()
                    if self.Text then
                        self.Text:SetText(text .. " (IMMUNE)")
                    end
                end
            end)
        end
    end
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)
