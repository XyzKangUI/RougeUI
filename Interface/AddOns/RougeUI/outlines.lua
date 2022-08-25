local CL = {}

local classcolors = {
	["focus"] = "Interface\\AddOns\\RougeUI\\textures\\target\\FocusFrame",
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


function CL:CreateTargetOutlines(unit)
	if not self.TT then
		self.TT = CreateFrame("Frame", nil, TargetFrame)
		self.TT:SetPoint("CENTER", TargetFramePortrait, "BOTTOMLEFT", -10, 6)
		self.TT:SetSize(124, 64)
		self.TT:SetScale(2)
		self.TT.texture = self.TT:CreateTexture(nil, "BORDER")
		self.TT.texture:SetAllPoints(self.TT)
		self.TT:Hide()
		--return self.TT
	end

	if not UnitIsPlayer(unit) then
		self.TT:Hide()
		return
	end

	local _, class = UnitClass(unit)
	self.TT.texture:SetTexture(classcolors[class])
	self.TT:Show()
end

function CL:CreateFocusOutlines(unit)
	if not self.FT then
		self.FT = CreateFrame("Frame", nil, FocusFrame)
		self.FT:SetPoint("CENTER", FocusFramePortrait, "BOTTOMLEFT", -10, 6)
		self.FT:SetSize(124, 62)
		self.FT:SetScale(2)
		self.FT.texture = self.FT:CreateTexture(nil, "BORDER")
		self.FT.texture:SetAllPoints(self.FT)
		self.FT:Hide()
		--return self.FT
	end

	if not UnitIsPlayer(unit) then
		self.FT:Hide()
		return
	end

	local _, class = UnitClass(unit)
	self.FT.texture:SetTexture(classcolors[class])
	self.FT:Show()

end

function CL:hookfunc()
	if self.portrait then
		if self.unit == "focus" then
			CL:CreateFocusOutlines(self.unit)
		end
		if self.unit == "target" then
			CL:CreateTargetOutlines(self.unit)
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


