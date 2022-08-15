local str_split = string.split
local UnitGUID = UnitGUID
local hookedFrames = {}

local function AddElements(plate)
	if plate:IsForbidden() then return end

	plate.CastBar.Text:SetFont(STANDARD_TEXT_FONT, 8)
	local sh = plate.selectionHighlight -- kang from evolvee
	sh:SetPoint("TOPLEFT", sh:GetParent(), "TOPLEFT", 1, -1)
	sh:SetPoint("BOTTOMRIGHT", sh:GetParent(), "BOTTOMRIGHT", -1, 1)
	plate.name:SetFont(STANDARD_TEXT_FONT, 8)
	plate.name:ClearAllPoints()
	plate.name:SetPoint('BOTTOMRIGHT', plate, 'TOPRIGHT', -6, -13)
	plate.name:SetJustifyH'RIGHT'
	for _, v in pairs({plate.healthBar.border:GetRegions(), plate.CastBar.Border}) do
		v:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	end
end

local function CastBarText(plate)
        if plate:IsForbidden() then return end
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
    local _, _, _, _, _, npcId = str_split("-", UnitGUID(unit))
	-- snake trap
    if npcId == "19833" or npcId == "19921" then
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
        	CastBarText(namePlateFrameBase.UnitFrame)
    	end
end

local  e = CreateFrame("Frame")
e:RegisterEvent("NAME_PLATE_UNIT_ADDED")
e:SetScript('OnEvent', OnEvent)


