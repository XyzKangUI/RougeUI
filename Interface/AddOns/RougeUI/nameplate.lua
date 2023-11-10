local _, RougeUI = ...
local str_split = string.split
local UnitGUID = UnitGUID
local U = UnitIsUnit
local select, hooksecurefunc = select, hooksecurefunc
local STANDARD_TEXT_FONT, IsActiveBattlefieldArena = STANDARD_TEXT_FONT, IsActiveBattlefieldArena
local WOW_PROJECT_ID, WOW_PROJECT_CLASSIC = WOW_PROJECT_ID, WOW_PROJECT_CLASSIC
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

if GetCVar("nameplateShowOnlyNames") == "1" then
    return
end

local function NameToArenaNumber(plate)
    if plate:IsForbidden() then
        return
    end

    if plate.unit:find("nameplate") then
        if select(1, IsActiveBattlefieldArena()) then
            for i = 1, 5 do
                if U(plate.unit, "arena" .. i) then
                    plate.name:SetText(i)
                    plate.name:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
                    plate.name:ClearAllPoints()
                    plate.name:SetPoint("BOTTOM", plate.healthBar.border, "TOP", 0, 2)
                    plate.name:SetJustifyH("CENTER")
                    break
                else
                    if RougeUI.db.ModPlates then
                        plate.name:SetFont(STANDARD_TEXT_FONT, 8)
                        plate.name:ClearAllPoints()
                        plate.name:SetPoint("BOTTOMRIGHT", plate, "TOPRIGHT", -6, -13)
                        plate.name:SetJustifyH("RIGHT")
                    end
                end
            end
        end
    end
end

local function AddElements(plate)
    if plate:IsForbidden() then
        return
    end

    if RougeUI.db.ModPlates then
        local sh = plate.selectionHighlight
        sh:SetPoint("TOPLEFT", sh:GetParent(), "TOPLEFT", 1, -1)
        sh:SetPoint("BOTTOMRIGHT", sh:GetParent(), "BOTTOMRIGHT", -1, 1)
        if RougeUI.db.ArenaNumbers and not select(1, IsActiveBattlefieldArena()) or not RougeUI.db.ArenaNumbers then
            plate.name:SetFont(STANDARD_TEXT_FONT, 8)
            plate.name:ClearAllPoints()
            plate.name:SetPoint("BOTTOMRIGHT", plate, "TOPRIGHT", -6, -13)
            plate.name:SetJustifyH("RIGHT")
        end
    end

    for _, v in pairs({ plate.healthBar.border:GetRegions() }) do
        if v then
            v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        end
    end
    if plate.CastBar and plate.CastBar.Border then
        plate.CastBar.Border:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
end

local function NiceOne(self)
    if self and self.Text and not self:IsForbidden() then
        self.Text:SetFont(STANDARD_TEXT_FONT, 8)
        self.Text:Show()
    end
end
if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
    hooksecurefunc("Nameplate_CastBar_AdjustPosition", NiceOne)
end

-- Modification of Knall's genius pet script. Ty <3
local function HidePlates(plate, unit)
    if plate:IsForbidden() then
        return
    end

    local _, _, _, _, _, npcId = str_split("-", UnitGUID(unit))
    -- Hide feral spirit, treants, army of the dead, snake trap, mirror image, underbelly croc, Crashin' Thrashin' Robot
    if npcId == "29264" or npcId == "1964" or npcId == "24207" or npcId == "19833" or npcId == "19921" or npcId == "31216" or npcId == "32441" or npcId == "17299" then
        plate.UnitFrame:Hide()
    else
        plate.UnitFrame:Show()
    end
end

local OnEvent = function(self, event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local base = ...
        local namePlateFrameBase = GetNamePlateForUnit(base, true);
        if not namePlateFrameBase then
            return
        end

        if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
            HidePlates(namePlateFrameBase, base)
        end
        AddElements(namePlateFrameBase.UnitFrame)
    elseif event == "ADDON_LOADED" then
        if RougeUI.db.ArenaNumbers then
            hooksecurefunc("CompactUnitFrame_UpdateName", NameToArenaNumber)
        end
        self:UnregisterEvent("ADDON_LOADED")
    end
end

local e = CreateFrame("Frame")
e:RegisterEvent("NAME_PLATE_UNIT_ADDED")
e:RegisterEvent("ADDON_LOADED")
e:SetScript('OnEvent', OnEvent)
