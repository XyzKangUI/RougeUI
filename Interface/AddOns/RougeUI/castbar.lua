local _, RougeUI = ...
local _G = getfenv(0)
local UnitCastingInfo = _G.UnitCastingInfo
local UnitChannelInfo = _G.UnitChannelInfo
local strformat, max = string.format, math.max

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

    t.Text:SetFontObject("Game12Font_o1")
    t:SetWidth(142)
    t:SetHeight(10)
    t.Border:SetHeight(40)
    t.Border:SetWidth(190)
    t.Border:ClearAllPoints()
    t.Border:SetPoint("TOPLEFT", t, "TOPLEFT", -24, 15)
    t.Icon:SetHeight(16)
    t.Icon:SetWidth(16)
    t.Icon:ClearAllPoints()
    t.Icon:SetPoint("RIGHT", t, "LEFT", -5, 0)
    t.Text:ClearAllPoints()
    t.Text:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 2, -5)
    t.Text:SetJustifyH("LEFT")
    t.Text:SetShadowOffset(0, 0)

    f.Text:SetFontObject("Game12Font_o1")
    f:SetWidth(142)
    f:SetHeight(10)
    f.Border:SetHeight(40)
    f.Border:SetWidth(190)
    f.Border:ClearAllPoints()
    f.Border:SetPoint("TOPLEFT", f, "TOPLEFT", -24, 15)
    f.Icon:SetHeight(16)
    f.Icon:SetWidth(16)
    f.Icon:ClearAllPoints()
    f.Icon:SetPoint("RIGHT", f, "LEFT", -5, 0)
    f.Text:ClearAllPoints()
    f.Text:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 2, -5)
    f.Text:SetJustifyH("LEFT")
    f.Text:SetShadowOffset(0, 0)
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
            self.timer:SetText(strformat("%.1f", max(self.maxValue - self.value, 0)))
        elseif self.channeling then
            self.timer:SetText(strformat("%.1f", max(self.value, 0)))
        else
            self.timer:SetText("")
        end
        self.update = .1
    else
        self.update = self.update - elapsed
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
            FocusFrameSpellBar:HookScript("OnUpdate", c_OnUpdate_Hook)
            TargetFrameSpellBar:HookScript("OnUpdate",c_OnUpdate_Hook)
            hooksecurefunc("CastingBarFrame_OnEvent", function(self, event, ...)
                local arg1 = ...
                local unit = self.unit;

                if self:IsForbidden() or not (self == TargetFrameSpellBar or self == FocusFrameSpellBar) or arg1 ~= unit then
                    return
                end

                local name, text, name2, text2

                if event == "UNIT_SPELLCAST_START" then
                    name, text = UnitCastingInfo(unit)
                elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                    name, text = UnitChannelInfo(unit)
                elseif event == "UNIT_SPELLCAST_INTERRUPTIBLE" then
                    name, text = UnitCastingInfo(unit)
                    name2, text2 = UnitChannelInfo(unit)
                    if self.Text and (name or name2) then
                        self.Text:SetText(text or text2)
                    end
                else
                    return
                end

                if self.BorderShield:IsShown() and (name or name2) then
                    self.BorderShield:SetAlpha(0)
                    if self.Text then
                        self.Text:SetText((text or text2) .. " (IMMUNE)")
                    end
                end
            end)
        end
    end
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)
