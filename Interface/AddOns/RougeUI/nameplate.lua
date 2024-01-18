local _, RougeUI = ...
local floor, select, tonumber = math.floor, select, tonumber
local UnitName, STANDARD_TEXT_FONT = UnitName, STANDARD_TEXT_FONT
local IsInInstance, GetNumArenaOpponents = IsInInstance, GetNumArenaOpponents
local UnitCanAttack = UnitCanAttack
local interval = 0.1
local time = 0

local function AddElements(plate, time)
    local _, border, _, _, _, _, name, levelText = plate:GetRegions()

    if plate:IsMouseOver() then
        if UnitCanAttack("player", "mouseover") then
            name:SetTextColor(1, 0, 0)
        else
            name:SetTextColor(1, 0.82, 0)
        end
    else
        name:SetTextColor(1, 1, 1)
    end

    if time >= interval then
        time = 0

        if not plate.skinned then
            border:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            plate.skinned = true
        end

        if RougeUI.db.ModPlates then
            name:SetFont(STANDARD_TEXT_FONT, 9)
            name:ClearAllPoints()
            name:SetPoint("BOTTOMRIGHT", plate, "TOPRIGHT", -6, -13)
            name:SetJustifyH("RIGHT")
            levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
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
end

local function onUpdate(self, elapsed)
    local plates = WorldFrame:GetNumChildren()

    time = time + elapsed

    for i = 1, plates do
        local plate = select(i, WorldFrame:GetChildren())
        local _, region = plate:GetRegions()
        if region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\Tooltips\\Nameplate-Border" then
            AddElements(plate, time)
        end
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
