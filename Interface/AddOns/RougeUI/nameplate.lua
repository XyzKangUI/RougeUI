local _, RougeUI = ...
local floor, select, tonumber = math.floor, select, tonumber
local UnitName, STANDARD_TEXT_FONT = UnitName, STANDARD_TEXT_FONT
local IsInInstance, GetNumArenaOpponents = IsInInstance, GetNumArenaOpponents
local UnitCanAttack = UnitCanAttack
local activePlates = {}

if not C_NamePlate then return end

local function AddElements(plate, unit)
    local _, castBar = plate:GetChildren()
    local _, border, cbborder, _, _, overlay, name, levelText, bossicon, raidicon, elite = plate:GetRegions()

    plate.castBar = castBar
    plate.unit = unit
    name:Hide()

    -- Create name
    if not plate.newName then
        local newName = plate:CreateFontString(nil, "ARTWORK")
        newName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        newName:SetWidth(150)
        newName:SetHeight(9)
        newName:SetPoint("BOTTOM", border, "TOP", 0, -15)
        newName:SetJustifyH("CENTER")
        newName:SetTextColor(1, 1, 1)
        plate.newName = newName
    end

    -- Create castBar text
    if not plate.castText then
        plate.castText = plate:CreateFontString(nil, "ARTWORK", "SystemFont_Outline")
        plate.castText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        plate.castText:SetSize(120, 16)
        plate.castText:SetPoint("CENTER", plate.castBar, "CENTER", 0, 1)
    end

    -- Set name
    plate.newName :SetText(name:GetText())

    -- Hide stuff
    bossicon:SetAlpha(0)
    raidicon:SetAlpha(0)
    elite:SetAlpha(0)
    overlay:ClearAllPoints()
    overlay:SetPoint("CENTER", UIParent, "CENTER", 10000, 10000)

    -- Color border
    border:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)

    -- Extra mods
    if RougeUI.db.ModPlates and not RougeUI.db.AsuriFrame then
        plate.newName:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        plate.newName:ClearAllPoints()
        plate.newName:SetPoint("BOTTOMRIGHT", plate, "TOPRIGHT", -9, -16)
        plate.newName:SetJustifyH("RIGHT")
        levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    else
        plate.newName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        plate.newName:ClearAllPoints()
        plate.newName:SetPoint("BOTTOM", border, "TOP", 0, -15)
    end

    if RougeUI.db.NoLevel or RougeUI.db.AsuriFrame then
        if border then
            border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\nolevel\\Nameplate-Border-nolevel")
        end
        if levelText then
            levelText:Hide()
            levelText:SetAlpha(0)
        end

        local HealthBar = plate:GetChildren()
        if HealthBar then
            HealthBar:SetWidth(148)
        end
    end

    -- Arena numbers
    local _, type = IsInInstance()
    if RougeUI.db.ArenaNumbers and type == "arena" then
        for i = 1, 5 do
            if UnitIsUnit(unit, "arena" .. i) then
                plate.newName:SetText(i)
                plate.newName:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
                plate.newName:ClearAllPoints()
                plate.newName:SetPoint("BOTTOM", plate, "TOP", 0, -15)
                plate.newName:SetJustifyH("CENTER")
                levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not RougeUI.db.ModPlates and not RougeUI.db.AsuriFrame then
            self:UnregisterAllEvents()
            self:Hide()
            return
        end
    end

    if event == "PLAYER_ENTERING_WORLD" then
        wipe(activePlates)
        return
    end

    local unit = ...
    if not unit then return end

    local plate =  C_NamePlate.GetNamePlateForUnit(unit)
    if not plate then
        return
    end

    if event == "NAME_PLATE_UNIT_ADDED" then
        AddElements(plate, unit)
        activePlates[plate] = true
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        activePlates[plate] = nil
    end
end)

frame:SetScript("OnUpdate", function()
    for plate in pairs(activePlates) do
        if plate and plate:IsShown() then

            -- Color mouseover names
            if plate.newName then
                if plate:IsMouseOver() then
                    if UnitCanAttack("player", "mouseover") then
                        plate.newName:SetTextColor(1, 0, 0)
                    else
                        plate.newName:SetTextColor(1, 0.82, 0)
                    end
                else
                    plate.newName:SetTextColor(1, 1, 1)
                end
            end

            -- Unit is a ghost.. why show a plate?
            if UnitIsGhost(plate.unit) then
                plate:SetAlpha(0)
            else
                plate:SetAlpha(1)
            end

            -- Set cast text
            local cb = plate.castBar
            if not cb or not plate.castText then return end

            if cb:IsShown() then
                local name, _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(plate.unit)
                if not name then
                    name, _, _, _, _, _, _, _, notInterruptible = UnitChannelInfo(plate.unit)
                end

                if name then
                    plate.castText:SetText(name)
                    if not plate.castText:IsShown() then
                        plate.castText:Show()
                    end
                else
                    plate.castText:SetText("")
                    if plate.castText:IsShown() then
                        plate.castText:Hide()
                    end
                end
            else
                plate.castText:SetText("")
                if plate.castText:IsShown() then
                    plate.castText:Hide()
                end
            end
        end
    end
end)