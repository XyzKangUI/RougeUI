local addonName, RougeUI = ...
local str_split, select = string.split, select
local UnitGUID, U = UnitGUID, UnitIsUnit
local IsActiveBattlefieldArena, STANDARD_TEXT_FONT = IsActiveBattlefieldArena, STANDARD_TEXT_FONT
local WOW_PROJECT_ID, WOW_PROJECT_CLASSIC = WOW_PROJECT_ID, WOW_PROJECT_CLASSIC
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local ClassicEra = false
local currentPlate, highlightBorder = nil, nil

local function NameToArenaNumber(plate)
    if plate:IsForbidden() or not plate.unit:find("nameplate") or not IsActiveBattlefieldArena() then
        return
    end

    for i = 1, 5 do
        if U(plate.unit, "arena" .. i) then
            plate.name:SetText(i)
            plate.name:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            plate.name:ClearAllPoints()
            plate.name:SetPoint("BOTTOM", plate.HealthBarsContainer.border, "TOP", 0, 2)
            break
        else
            if RougeUI.db.ModPlates and not RougeUI.db.AsuriFrame then
                plate.name:SetFont(STANDARD_TEXT_FONT, 8)
                plate.name:ClearAllPoints()
                plate.name:SetPoint("CENTER", plate, "CENTER", 0, 5)
            end
        end
    end
end

local function AddElements(plate)
    if not plate or not plate:IsShown() then
        return
    end

    if (RougeUI.db.ModPlates and not RougeUI.db.AsuriFrame) then
        if not IsActiveBattlefieldArena() then
            plate.name:SetFont(STANDARD_TEXT_FONT, 8)
            plate.name:ClearAllPoints()
            plate.name:SetPoint("CENTER", plate, "CENTER", 0, 5)
        end
    end

    if RougeUI.db.NoLevel or RougeUI.db.AsuriFrame then
        local border = plate.HealthBarsContainer.border:GetRegions()
        if border then
            border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\nolevel\\Nameplate-Border-nolevel")
        end
        if plate.LevelFrame then
            plate.LevelFrame:Hide()
        end
        if plate.HealthBarsContainer then
            plate.HealthBarsContainer:ClearAllPoints()
            plate.HealthBarsContainer:SetPoint("BOTTOMLEFT", plate, "BOTTOMLEFT", 4, 4)
            plate.HealthBarsContainer:SetPoint("BOTTOMRIGHT", plate, "BOTTOMRIGHT", -4, 4)
        end
        if plate.castBar then
            plate.castBar:ClearAllPoints()
            plate.castBar:SetPoint("TOP", plate.healthBar, "BOTTOM", 8, -9)
        end
    else
        if plate.LevelFrame and plate.LevelFrame.levelText then
            plate.LevelFrame.levelText:SetFont(STANDARD_TEXT_FONT, 8)
        end
    end

    if plate.HealthBarsContainer and plate.HealthBarsContainer.border then
        for _, v in pairs({ plate.HealthBarsContainer.border:GetRegions() }) do
            if v then
                v:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            end
        end
    end

    if plate.castBar and plate.castBar.Border then
        plate.castBar.Border:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
end

local function NiceOne(self)
    if self and self.Text and not self:IsForbidden() then
        self.Text:SetFont(STANDARD_TEXT_FONT, 8)
        self.Text:Show()
    end
end

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and Nameplate_CastBar_AdjustPosition then
    hooksecurefunc("Nameplate_CastBar_AdjustPosition", NiceOne)
end

-- Modification of Knall's genius pet script. Ty <3
local function HidePlates(plate, unit)
    if plate:IsForbidden() then
        return
    end

    local guid = UnitGUID(unit)
    if not guid then
        return
    end
    local _, _, _, _, _, npcId = str_split("-", guid)

    -- Hide feral spirit, treants, army of the dead, snake trap, mirror image, underbelly croc, Crashin' Thrashin' Robot, Shadowy Apparitions
    if npcId == "29264" or npcId == "1964" or npcId == "24207" or npcId == "19833" or npcId == "19921" or
            npcId == "31216" or npcId == "32441" or npcId == "17299" or npcId == "46954" then
        plate.UnitFrame:Hide()
    else
        plate.UnitFrame:Show()
    end
end

local function HighlightTargetPlate()
    highlightBorder:Hide()
    currentPlate = nil

    local plate = UnitExists("target") and C_NamePlate.GetNamePlateForUnit("target")
    if plate and plate:IsShown() and currentPlate ~= plate then
        if UnitIsUnit("target", plate.namePlateUnitToken or "") then
            highlightBorder:SetParent(plate)
            highlightBorder:SetAllPoints(plate)
            highlightBorder:SetFrameLevel(plate:GetFrameLevel() + 1)
            highlightBorder:SetAlpha(0.9)
            highlightBorder:Show()
            currentPlate = plate
            --if highlightBorder.anim then
            --    highlightBorder.anim:Stop()
            --    highlightBorder.anim:Play()
            --end
        end
    end
end

local function OnEvent(self, event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local unit = ...
        local namePlateFrameBase = GetNamePlateForUnit(unit, false);
        if not namePlateFrameBase or namePlateFrameBase:IsForbidden() then
            return
        end

        if not ClassicEra then
            HidePlates(namePlateFrameBase, unit)
        end
        AddElements(namePlateFrameBase.UnitFrame)

        --if RougeUI.db.ModPlates and UnitIsUnit("target", unit) then
        --    HighlightTargetPlate()
        --end
    elseif event == "ADDON_LOADED" and ... == addonName then
        if GetCVar("nameplateShowOnlyNames") == "1" then
            return
        end

        self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        ClassicEra = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

        if RougeUI.db.ArenaNumbers and CompactUnitFrame_UpdateName then
            hooksecurefunc("CompactUnitFrame_UpdateName", NameToArenaNumber)
        end

        --if RougeUI.db.ModPlates then
        --    highlightBorder = CreateFrame("Frame")
        --    highlightBorder:SetFrameStrata("HIGH")
        --    highlightBorder:Hide()
        --
        --    local borderTexture = highlightBorder:CreateTexture(nil, "OVERLAY")
        --    borderTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\Nameplate-highlight")
        --    borderTexture:SetAllPoints(highlightBorder)
        --    borderTexture:SetVertexColor(1, 1, 1)
        --
        --    --highlightBorder.anim = highlightBorder:CreateAnimationGroup()
        --    --local alpha = highlightBorder.anim:CreateAnimation("Alpha")
        --    --alpha:SetFromAlpha(0.5)
        --    --alpha:SetToAlpha(1)
        --    --alpha:SetDuration(0.2)
        --    --alpha:SetSmoothing("IN_OUT")
        --
        --    self:RegisterEvent("PLAYER_TARGET_CHANGED")
        --    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
        --end
    elseif event == "PLAYER_TARGET_CHANGED" then
        HighlightTargetPlate()
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        if RougeUI.db.ModPlates and currentPlate and currentPlate.unit == ... then
            highlightBorder:Hide()
            currentPlate = nil
        end
    end
end

local e = CreateFrame("Frame")
e:RegisterEvent("ADDON_LOADED")
e:SetScript('OnEvent', OnEvent)