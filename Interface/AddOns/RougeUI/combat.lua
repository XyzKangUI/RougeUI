local UnitAffectingCombat = UnitAffectingCombat
local pairs = pairs
local interval = 0.2
local lastupdate = 0

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

local function FrameOnUpdate(self, elapsed)
	if (RougeUI.CombatIndicator == false) then
		self:SetScript("OnUpdate", nil)
		return
	end
	lastupdate = lastupdate + elapsed
	if lastupdate >= interval then
		lastupdate = 0
		for _,ciFrame in pairs(self.ciFrames) do
			if UnitAffectingCombat(ciFrame.unit) then 
				ciFrame:Show() 
			else
				ciFrame:Hide() 
			end 
		end
	end
end


local ciCore = CreateFrame("Frame")
ciCore.ciFrames = {}
ciCore:SetScript("OnUpdate", FrameOnUpdate)

ciCore.ciFrames["target"] = CreateCombatIndicatorForUnit("target", TargetFrame)
ciCore.ciFrames["focus"] = CreateCombatIndicatorForUnit("focus", FocusFrame)
