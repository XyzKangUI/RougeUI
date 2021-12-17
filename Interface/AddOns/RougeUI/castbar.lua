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

t.Text:SetFont(STANDARD_TEXT_FONT, 10)
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

f.Text:SetFont(STANDARD_TEXT_FONT, 11)
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

CastingBarFrame.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
CastingBarFrame.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
CastingBarFrame.Spark:SetHeight(50)
CastingBarFrame.Text:ClearAllPoints()
CastingBarFrame.Text:SetPoint("CENTER", 0, 1)
CastingBarFrame.Border:SetWidth(CastingBarFrame.Border:GetWidth() + 4)
CastingBarFrame.Flash:SetWidth(CastingBarFrame.Flash:GetWidth() + 4)
CastingBarFrame.BorderShield:SetWidth(CastingBarFrame.BorderShield:GetWidth() + 4)
CastingBarFrame.Border:SetPoint("TOP", 0, 26)
CastingBarFrame.Flash:SetPoint("TOP", 0, 26)
CastingBarFrame.BorderShield:SetPoint("TOP", 0, 26)

local function c_OnUpdate_Hook(self, elapsed)
	    if not self.timer then return end
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
	GradientColour(self)
end

f:HookScript("OnUpdate", c_OnUpdate_Hook)
t:HookScript("OnUpdate", c_OnUpdate_Hook)

    --