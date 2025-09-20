local _, RougeUI = ...
local select, UnitExists = select, UnitExists
local UnitName, STANDARD_TEXT_FONT = UnitName, STANDARD_TEXT_FONT
local IsInInstance, GetNumArenaOpponents = IsInInstance, GetNumArenaOpponents
local UnitCanAttack, UnitCastingInfo, UnitChannelInfo = UnitCanAttack, UnitCastingInfo, UnitChannelInfo

local time = 0
local np = {}

local function AddElements(plate, elapsed)
    local _, border, cbborder, _, _, overlay, name, levelText, bossicon, raidicon, elite = plate:GetRegions()
    local castBar = plate:GetChildren()
    plate.castBar = castBar

    -- Mouseover coloring
    if plate:IsMouseOver() then
        if UnitCanAttack("player", "mouseover") then
            if plate.newName then
                plate.newName:SetTextColor(1, 0, 0)
            elseif name then
                name:SetTextColor(1, 0, 0)
            end
        else
            if plate.newName then
                plate.newName:SetTextColor(1, 0.82, 0)
            elseif name then
                name:SetTextColor(1, 0.82, 0)
            end
        end
    else
        if plate.newName then
            plate.newName:SetTextColor(1, 1, 1)
        elseif name then
            name:SetTextColor(1, 1, 1)
        end
    end

    if not np[plate] then
        np[plate] = true

        -- Create newName
        if not plate.newName then
            local newName = plate:CreateFontString(nil, "ARTWORK")
            newName:SetFont(STANDARD_TEXT_FONT, 12)
            newName:SetWidth(150)
            newName:SetHeight(9)
            newName:SetPoint("BOTTOM", border, "TOP", 0, -15)
            newName:SetTextColor(1, 1, 1)
            plate.newName = newName
        end

        -- Create castText
        if not plate.castText then
            plate.castText = plate:CreateFontString(nil, "ARTWORK", "SystemFont_Outline")
            plate.castText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
            plate.castText:SetSize(120, 16)
        end

        -- Hide default icons
        bossicon:SetAlpha(0)
        raidicon:SetAlpha(0)
        elite:SetAlpha(0)

        -- Store cbborder for cast coloring
        plate.cbborder = cbborder
    end

    plate.newName:SetText(name:GetText())
    name:SetAlpha(0)

    -- Apply border color
    border:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)

    -- ModPlates tweaks
    if RougeUI.db.ModPlates then
        plate.newName:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        plate.newName:ClearAllPoints()
        plate.newName:SetPoint("BOTTOM", border, "TOP", 0, -17)
    else
        plate.newName:SetFont(STANDARD_TEXT_FONT, 12)
        plate.newName:ClearAllPoints()
        plate.newName:SetPoint("BOTTOM", border, "TOP", 0, -15)
    end

    -- Arena numbers
    local _, type = IsInInstance()
    if RougeUI.db.ArenaNumbers and type == "arena" then
        for i = 1, GetNumArenaOpponents() do
            if UnitName("arena" .. i) == name:GetText() then
                plate.newName:SetText(i)
                plate.newName:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
                plate.newName:ClearAllPoints()
                plate.newName:SetPoint("BOTTOM", plate, "TOP", 0, -15)
                levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            end
        end
    end

    -- Castbar update (old shits, rip warmane banning awesomewotlk)
    local cb = plate.castBar
    if cb and plate.castText then
        if cb:IsShown() then
            local cname

            for _, unit in ipairs({"arena1","arena2","arena3","party1","party2","party3", "mouseover"}) do
                if UnitExists(unit) and UnitName(unit) == name:GetText() then
                    cname = UnitCastingInfo(unit)
                    if not cname then
                        cname = UnitChannelInfo(unit)
                    end
                    break
                end
            end

            if cname then
                plate.castText:ClearAllPoints()
                plate.castText:SetPoint("CENTER", plate.castBar, "CENTER", 20, -19)

                if plate.cbborder then
                    plate.cbborder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
                plate.castText:SetText(cname)
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

local function onUpdate(self, elapsed)
    time = time + elapsed
    local plates = WorldFrame:GetNumChildren()

    for i = 1, plates do
        local plate = select(i, WorldFrame:GetChildren())
        local _, region = plate:GetRegions()
        if region and region:GetObjectType() == "Texture" then
            AddElements(plate, elapsed)
        end
    end

    if time >= 0.1 then
        time = 0
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    if not (GetCVarBool("nameplateShowEnemies") or GetCVarBool("nameplateShowFriends")) then
        return
    end

    if RougeUI.db.ModPlates or RougeUI.db.Colval < 1 then
        frame:SetScript("OnUpdate", onUpdate)
    end
end)
