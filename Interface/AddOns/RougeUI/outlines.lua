local CL = {}
CL.NF = {}

local classcolors = {
    ["ROGUE"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Rogue",
    ["PRIEST"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Priest",
    ["WARRIOR"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Warrior",
    ["PALADIN"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Paladin",
    ["DEATHKNIGHT"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Deathknight",
    ["HUNTER"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Hunter",
    ["DRUID"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Druid",
    ["MAGE"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Mage",
    ["SHAMAN"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Shaman",
    ["WARLOCK"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Warlock",
}

function CL:CreateClassOutlines(unit, frame)
  if not self.NF[unit] then
    self.NF[unit] = CreateFrame("Frame", nil, frame)
    self.NF[unit]:SetPoint("CENTER", frame.portrait, "BOTTOMLEFT", -10, 6)
    self.NF[unit]:SetSize(124, 62)
    self.NF[unit]:SetScale(frame:GetScale() * 2)
    self.NF[unit].texture = self.NF[unit]:CreateTexture(nil, "BORDER")
    self.NF[unit].texture:SetAllPoints(self.NF[unit])
    self.NF[unit]:Hide()
  end

    if not UnitIsPlayer(unit) then
        self.NF[unit]:Hide()
        return
    end

    local _, class = UnitClass(unit)
    self.NF[unit].texture:SetTexture(classcolors[class])
    self.NF[unit]:Show()
end

function CL:hookfunc()
	if self.portrait then
		if self.unit == "focus" or self.unit == "target" then
			CL:CreateClassOutlines(self.unit, self)
		end
	end
end

function CL:ADDON_LOADED()
	hooksecurefunc("UnitFramePortrait_Update", self.hookfunc)
end

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("ADDON_LOADED")
eventframe:SetScript("OnEvent", function(self, event, ...)
	if RougeUI.classoutline then
		CL[event](CL, ...)
	end
	self:UnregisterEvent("ADDON_LOADED")
end)
