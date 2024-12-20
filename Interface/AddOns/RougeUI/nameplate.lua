local _, RougeUI = ...
local floor, select, tonumber = math.floor, select, tonumber
local UnitName, STANDARD_TEXT_FONT = UnitName, STANDARD_TEXT_FONT
local IsInInstance, GetNumArenaOpponents = IsInInstance, GetNumArenaOpponents
local UnitCanAttack = UnitCanAttack
local np = {}

local function AddElements(plate, unit)
    local _, border, cbborder, _, _, overlay, name, levelText, bossicon, raidicon, elite = plate:GetRegions()

    plate.unit = unit

    if not np[plate] then
        np[plate] = true
        plate:HookScript("OnUpdate", function(self)
            self:SetAlpha(1)

            if plate:IsMouseOver() then
                if UnitCanAttack("player", "mouseover") then
                    name:SetTextColor(1, 0, 0)
                else
                    name:SetTextColor(1, 0.82, 0)
                end
            else
                name:SetTextColor(1, 1, 1)
            end
        end)
    end

    border:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    bossicon:SetAlpha(0)
    raidicon:SetAlpha(0)
    elite:SetAlpha(0)
    overlay:ClearAllPoints()
    overlay:SetPoint("CENTER", UIParent, "CENTER", 10000, 10000)

    if RougeUI.db.ModPlates then
        name:SetFont(STANDARD_TEXT_FONT, 9)
        name:ClearAllPoints()
        name:SetPoint("BOTTOMRIGHT", plate, "TOPRIGHT", -6, -13)
        name:SetJustifyH("RIGHT")
        levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    end

    if RougeUI.db.NoLevel then
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

    local _, type = IsInInstance()
    if RougeUI.db.ArenaNumbers and type == "arena" then
        for i = 1, GetNumArenaOpponents() do
            local text = name:GetText()
            if UnitName("arena" .. i) == text then
                name:SetText(i)
            end
            local nr = tonumber(text)
            if nr then
                name:SetText(nr)
                name:ClearAllPoints()
                name:SetPoint("BOTTOM", plate, "TOP", 0, -15)
                name:SetJustifyH("CENTER")
                name:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
                levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
frame:SetScript("OnEvent", function(self, event, ...)
    if not (GetCVarBool("nameplateShowEnemies") or GetCVarBool("nameplateShowFriends")) then
        return
    end

    local unit = ...

    if not unit then return end
    local plate =  C_NamePlate.GetNamePlateForUnit(unit)
    if not plate then
        return
    end

    AddElements(plate, unit)
end)