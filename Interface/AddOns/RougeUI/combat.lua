local UnitAffectingCombat = UnitAffectingCombat
local pairs = pairs

local function CreateCombatIndicatorForUnit(unit, frame)
	local ciFrame = CreateFrame("Frame", nil, frame)
	ciFrame:SetPoint("LEFT", frame, "RIGHT", -25, 10)
	ciFrame:SetSize(30, 30)
	ciFrame.texture = ciFrame:CreateTexture(nil, "BORDER")
	ciFrame.texture:SetAllPoints(ciFrame)
	ciFrame.texture:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
	ciFrame:Hide()
	ciFrame.unit = unit
	return ciFrame
end

local ciCore = CreateFrame("Frame")
ciCore.ciFrames = {}
ciCore:RegisterEvent("UNIT_FLAGS")
ciCore:RegisterEvent("PLAYER_TARGET_CHANGED")
ciCore:RegisterEvent("PLAYER_FOCUS_CHANGED")
ciCore:RegisterEvent("ADDON_LOADED")

function ciCore:UNIT_FLAGS(unitTarget)
	if not (unitTarget == "target" or unitTarget == "focus") then return end

	for _,ciFrame in pairs(self.ciFrames) do
		if UnitAffectingCombat(ciFrame.unit) then 
			ciFrame:Show() 
		else
			ciFrame:Hide()
		end 
	end
end

function ciCore:PLAYER_TARGET_CHANGED()
	if UnitAffectingCombat("target") then 
		self.ciFrames["target"]:Show() 
	else
		self.ciFrames["target"]:Hide() 
	end
end

function ciCore:PLAYER_FOCUS_CHANGED()
	if UnitAffectingCombat("focus") then 
		self.ciFrames["focus"]:Show() 
	else
		self.ciFrames["focus"]:Hide() 
	end
end

ciCore:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" and not RougeUI.CombatIndicator then
		self:UnregisterAllEvents()
		self:SetScript("OnEvent", nil)
	elseif event ~= "ADDON_LOADED" then
		self[event](self, ...)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)


ciCore.ciFrames["target"] = CreateCombatIndicatorForUnit("target", TargetFrame)
ciCore.ciFrames["focus"] = CreateCombatIndicatorForUnit("focus", FocusFrame)
