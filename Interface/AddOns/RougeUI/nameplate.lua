local str_split = string.split
local UnitGUID = UnitGUID
local hookedFrames = {}
local U = UnitIsUnit
local select = select
local arenaframes

local function NameToArenaNumber(plate)
	if plate:IsForbidden() then return end

	if plate.unit:find("nameplate") then
 		if select(1, IsActiveBattlefieldArena()) then
			for i=1,5 do 
				if U(plate.unit, "arena"..i) then
					plate.name:SetText(i)
					plate.name:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
					plate.name:ClearAllPoints()
					plate.name:SetPoint("BOTTOM", plate.healthBar.border, "TOP", 0, 2)
					plate.name:SetJustifyH("CENTER")
					break
				else
					plate.name:SetFont(STANDARD_TEXT_FONT, 8)
					plate.name:ClearAllPoints()
					plate.name:SetPoint("BOTTOMRIGHT", plate, "TOPRIGHT", -6, -13)
					plate.name:SetJustifyH("RIGHT")
				end
			end
		end
	end
end

local function AddElements(plate)
	if plate:IsForbidden() then return end

	plate.CastBar.Text:SetFont(STANDARD_TEXT_FONT, 8)
	local sh = plate.selectionHighlight -- kang from evolvee
	sh:SetPoint("TOPLEFT", sh:GetParent(), "TOPLEFT", 1, -1)
	sh:SetPoint("BOTTOMRIGHT", sh:GetParent(), "BOTTOMRIGHT", -1, 1)
	if RougeUI.ArenaNumbers and not select(1, IsActiveBattlefieldArena()) or not RougeUI.ArenaNumbers then
		plate.name:SetFont(STANDARD_TEXT_FONT, 8)
		plate.name:ClearAllPoints()
		plate.name:SetPoint("BOTTOMRIGHT", plate, "TOPRIGHT", -6, -13)
		plate.name:SetJustifyH("RIGHT")
	end

	for _, v in pairs({plate.healthBar.border:GetRegions(), plate.CastBar.Border}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end

	if not hookedFrames[plate] then
		plate.CastBar:HookScript("OnShow", function()
			if not plate.CastBar.Text:IsShown() then
				plate.CastBar.Text:Show();
			end
		end)
		hookedFrames[plate] = plate
	end
end

-- Modification of Knall's genius pet script. Ty <3
local function HidePlates(plate, unit)
    if plate:IsForbidden() then return end

    local _, _, _, _, _, npcId = str_split("-", UnitGUID(unit))
	-- treants, snake trap
    if npcId == "1964" or npcId == "19833" or npcId == "19921" then
        plate.UnitFrame:Hide()
    else
        plate.UnitFrame:Show()
    end
end

local OnEvent = function(self, event, ...)
	if event == "NAME_PLATE_UNIT_ADDED" then
		local base = ...
		local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(base, issecure());
		if not namePlateFrameBase then return end

		HidePlates(namePlateFrameBase, base)
        	AddElements(namePlateFrameBase.UnitFrame)
    	elseif event == "ADDON_LOADED" then
		if RougeUI.ArenaNumbers == true then
			hooksecurefunc("CompactUnitFrame_UpdateName", NameToArenaNumber)
		end
		self:UnregisterEvent("ADDON_LOADED")
	end
end

local e = CreateFrame("Frame")
e:RegisterEvent("NAME_PLATE_UNIT_ADDED")
e:RegisterEvent("ADDON_LOADED")
e:SetScript('OnEvent', OnEvent)