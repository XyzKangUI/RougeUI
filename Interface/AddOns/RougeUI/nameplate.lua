local addonName, RougeUI = ...
local str_split = string.split
local UnitGUID, U = UnitGUID, UnitIsUnit
local UnitExists, UnitIsUnit = UnitExists, UnitIsUnit
local IsActiveBattlefieldArena, STANDARD_TEXT_FONT = IsActiveBattlefieldArena, STANDARD_TEXT_FONT
local WOW_PROJECT_ID, WOW_PROJECT_CLASSIC = WOW_PROJECT_ID, WOW_PROJECT_CLASSIC
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local ClassicEra = false

local function GetHealthBar(plate)
    return plate.healthBar or (plate.HealthBarsContainer and plate.HealthBarsContainer.healthBar)
end

local function NameToArenaNumber(plate)
    if not plate or plate:IsForbidden() or not plate.unit or not plate.unit:find("nameplate")
            or not IsActiveBattlefieldArena() or not plate.name then
        return
    end

    for i = 1, 5 do
        if U(plate.unit, "arena" .. i) then
            plate.name:SetText(i)
            plate.name:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            plate.name:ClearAllPoints()
            local hb = GetHealthBar(plate)
            plate.name:SetPoint("BOTTOM", hb or plate, "TOP", 0, 2)
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

local function customCastbar(castBar)
    if not castBar or castBar:IsForbidden() then
        return
    end
    if castBar.Text then
        castBar.Text:SetFont(STANDARD_TEXT_FONT, 8)
        castBar.Text:Show()
    end
    if castBar.Border then
        castBar.Border:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
end

local function StylePlate(plate)
    if not plate or plate:IsForbidden() then
        return
    end

    local hb = GetHealthBar(plate)
    if not hb then return end
    local bgTexture = hb.bgTexture

    if hb and not hb.RougeHealthBG then
        local bg = hb:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(hb)
        bg:SetColorTexture(0.2, 0.2, 0.2, 0.85)
        hb.RougeHealthBG = bg
    end

    if RougeUI.db.ModPlates and not RougeUI.db.AsuriFrame then
        if not IsActiveBattlefieldArena() and plate.name then
            plate.name:SetFont(STANDARD_TEXT_FONT, 8)
            plate.name:ClearAllPoints()
            plate.name:SetPoint("CENTER", plate, "CENTER", 0, 5)
        end
    end

    if RougeUI.db.NoLevel or RougeUI.db.AsuriFrame then
        if bgTexture then
            bgTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\nolevel\\Nameplate-Border-nolevel")
        end
        if plate.LevelFrame then
            plate.LevelFrame:Hide()
        end
        if plate.HealthBarsContainer then
            plate.HealthBarsContainer:ClearAllPoints()
            plate.HealthBarsContainer:SetPoint("BOTTOMLEFT", plate, "BOTTOMLEFT", 4, 4)
            plate.HealthBarsContainer:SetPoint("BOTTOMRIGHT", plate, "BOTTOMRIGHT", -4, 4)

            if bgTexture then
                local bw, bh = bgTexture:GetSize()
                hb:ClearAllPoints()
                hb:SetPoint("CENTER", plate.HealthBarsContainer, "CENTER", 0, 0)
                if bw and bw > 1 then hb:SetWidth(bw - 8) end
                if bh and bh > 1 then hb:SetHeight(bh - 4) end
            end
        end
        if plate.CastBarsContainer then
            plate.CastBarsContainer:ClearAllPoints()
            plate.CastBarsContainer:SetPoint("TOP", hb, "BOTTOM", 8, -9)
        end
    else
        if plate.LevelFrame and plate.LevelFrame.levelText then
            plate.LevelFrame.levelText:SetFont(STANDARD_TEXT_FONT, 8)
        end
    end

    if bgTexture then
        bgTexture:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
end

local function AddElements(plate)
    if not plate or not plate:IsShown() then
        return
    end

    if not plate.RougeHooked then
        if plate.UpdateAnchors then
            hooksecurefunc(plate, "UpdateAnchors", StylePlate)
        end
        local cb = plate.CastBarsContainer and plate.CastBarsContainer.castBar
        if cb then
            if cb.ApplyStyleAndAnchoring then
                hooksecurefunc(cb, "ApplyStyleAndAnchoring", customCastbar)
            end
            cb:HookScript("OnShow", customCastbar)
        end
        plate.RougeHooked = true
    end

    StylePlate(plate)

    local cb = plate.CastBarsContainer and plate.CastBarsContainer.castBar
    if cb then
        customCastbar(cb)
    end
end

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
    elseif event == "ADDON_LOADED" and ... == addonName then
        self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        ClassicEra = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

        if RougeUI.db.ArenaNumbers and CompactUnitFrame_UpdateName then
            hooksecurefunc("CompactUnitFrame_UpdateName", NameToArenaNumber)
        end
        
        if (RougeUI.db.NoLevel or RougeUI.db.AsuriFrame) and CompactUnitFrame_UpdateLevel then
            hooksecurefunc("CompactUnitFrame_UpdateLevel", function(frame)
                if frame and not frame:IsForbidden() and frame.unit and frame.unit:find("nameplate") then
                    if frame.LevelFrame then
                        frame.LevelFrame:Hide()
                    end
                end
             end)
         end
    end
end

local e = CreateFrame("Frame")
e:RegisterEvent("ADDON_LOADED")
e:SetScript('OnEvent', OnEvent)
