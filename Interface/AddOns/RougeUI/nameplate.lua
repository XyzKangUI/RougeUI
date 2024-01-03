local _, RougeUI = ...
local str_split, select = string.split, select
local UnitGUID, U = UnitGUID, UnitIsUnit
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local WOW_PROJECT_ID, WOW_PROJECT_CLASSIC = WOW_PROJECT_ID, WOW_PROJECT_CLASSIC
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local ClassicEra = false

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
    if RougeUI.db.ModPlates then
        if (RougeUI.db.ArenaNumbers and not IsActiveBattlefieldArena()) or not RougeUI.db.ArenaNumbers then
            plate.name:SetFont(STANDARD_TEXT_FONT, 8)
            plate.name:ClearAllPoints()
            plate.name:SetPoint("BOTTOMRIGHT", plate, "TOPRIGHT", -6, -13)
            plate.name:SetJustifyH("RIGHT")
        end
    end

    if RougeUI.db.NoLevel then
        local border = plate.healthBar.border:GetRegions()
        if border then
            border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\nolevel\\Nameplate-Border-nolevel")
        end
        if plate.LevelFrame then
            plate.LevelFrame:Hide()
        end
        if plate.healthBar then
            plate.healthBar:ClearAllPoints()
            plate.healthBar:SetPoint("BOTTOMLEFT", plate, "BOTTOMLEFT", 4, 4)
            plate.healthBar:SetPoint("BOTTOMRIGHT", plate, "BOTTOMRIGHT", -4, 4)
        end
        if plate.CastBar then
            plate.CastBar:ClearAllPoints()
            plate.CastBar:SetPoint("TOP", plate.healthBar, "BOTTOM", 8, -9)
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
        local unit = ...
        local namePlateFrameBase = GetNamePlateForUnit(unit, issecure());
        if not namePlateFrameBase or namePlateFrameBase:IsForbidden() then
            return
        end

        if not ClassicEra then
            HidePlates(namePlateFrameBase, unit)
        end
        AddElements(namePlateFrameBase.UnitFrame)
    elseif event == "PLAYER_LOGIN" then
        if GetCVar("nameplateShowOnlyNames") == "1" then
            self:UnregisterAllEvents()
            return
        end
        if RougeUI.db.ArenaNumbers then
            hooksecurefunc("CompactUnitFrame_UpdateName", NameToArenaNumber)
        end
        ClassicEra = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end

local e = CreateFrame("Frame")
e:RegisterEvent("NAME_PLATE_UNIT_ADDED")
e:RegisterEvent("PLAYER_LOGIN")
e:SetScript('OnEvent', OnEvent)