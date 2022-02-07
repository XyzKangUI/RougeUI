SetCVar("ShowClassColorInFriendlyNameplate", 1)
SetCVar("ShowClassColorInNameplate", 1)
SetCVar("nameplateMaxDistance", 41)

local function AddElements(plate)
	if (string.find(plate.unit, "nameplate") and not plate:IsForbidden()) then
		plate.CastBar.Text:SetFont(STANDARD_TEXT_FONT, 8)
		local sh = plate.selectionHighlight -- kang from evolvee
		sh:SetPoint("TOPLEFT", sh:GetParent(), "TOPLEFT", 1, -1)
		sh:SetPoint("BOTTOMRIGHT", sh:GetParent(), "BOTTOMRIGHT", -1, 1)
		plate.name:SetFont(STANDARD_TEXT_FONT, 8)
		plate.name:ClearAllPoints()
     		plate.name:SetPoint('BOTTOMRIGHT', plate, 'TOPRIGHT', -6, -13)
     		plate.name:SetJustifyH'RIGHT'
		for _, v in pairs({plate.healthBar.border:GetRegions(), plate.CastBar.Border}) do
                	v:SetVertexColor(0.05, 0.05, 0.05)
		end
	end
end

local hookedFrames = {}

local function CastBarText(plate)
    if string.find(plate.unit, "nameplate") then
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
end

local OnEvent = function(self, event, ...)
    if (event == "NAME_PLATE_UNIT_ADDED") then
        local base = ...
        local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(base, issecure());

        AddElements(namePlateFrameBase.UnitFrame)
	CastBarText(namePlateFrameBase.UnitFrame)
    end
end

local  e = CreateFrame'Frame'
e:RegisterEvent("NAME_PLATE_UNIT_ADDED")
e:SetScript('OnEvent', OnEvent)
