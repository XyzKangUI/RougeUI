local _, RougeUI = ...
local select, ipairs, pairs, wipe = select, ipairs, pairs, wipe
local UnitExists, UnitName, UnitCanAttack = UnitExists, UnitName, UnitCanAttack
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo
local IsInInstance, GetNumArenaOpponents = IsInInstance, GetNumArenaOpponents
local GetTime, GetCVarBool = GetTime, GetCVarBool
local WorldFrame = WorldFrame
local STANDARD_TEXT_FONT = STANDARD_TEXT_FONT

local time = 0
local numChildren = -1
local activePlates = {}
local unitKeys = {}

local cachedInstanceType = ""
local cachedArenaOpponents = 0

local trackedUnits = {
    "arena1", "arena2", "arena3",
    "arenapet1", "arenapet2", "arenapet3",
    "party1", "party2", "party3",
    "partypet1", "partypet2", "partypet3"
}

local function defaultNames(plate)
    plate.arenaFormatted = false
    plate.lastName = nil
    plate.newName:SetFont(
        STANDARD_TEXT_FONT, 12,
        RougeUI.db.ModPlates and "OUTLINE" or ""
    )
    plate.newName:ClearAllPoints()
    plate.newName:SetPoint("BOTTOM", plate.border, "TOP", 0, RougeUI.db.ModPlates and -17 or -15)
end

local function initPlate(plate)
    if plate.isInitialized then return end
    plate.isInitialized = true

    local _, border, cbborder, _, cbicon, _, name, levelText, bossicon, raidicon, elite = plate:GetRegions()
    local healthBar, castBar = plate:GetChildren()

    plate.healthBar = healthBar
    plate.castBar = castBar
    plate.border = border
    plate.cbborder = cbborder
    plate.cbicon = cbicon
    plate.oldName = name
    plate.levelText = levelText
    plate.arenaFormatted = false
    plate.cbborderColored = false
    plate.lastName = nil
    plate.lastIsOver = nil
    plate.lastCastName = nil

    bossicon:SetAlpha(0)
    raidicon:SetAlpha(0)
    elite:SetAlpha(0)
    name:SetAlpha(0)

    castBar:SetStatusBarColor(1, 0.7, 0)

    local newName = plate:CreateFontString(nil, "ARTWORK")
    newName:SetFont(STANDARD_TEXT_FONT, RougeUI.db.ModPlates and 10 or 12, RougeUI.db.ModPlates and "OUTLINE" or "")
    newName:SetWidth(150)
    newName:SetHeight(9)
    newName:SetPoint("BOTTOM", border, "TOP", 0, RougeUI.db.ModPlates and -17 or -15)
    newName:SetTextColor(1, 1, 1)
    plate.newName = newName

    if RougeUI.db.ModPlates then
        levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    end

    local castText = plate:CreateFontString(nil, "ARTWORK", "SystemFont_Outline")
    castText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    castText:SetSize(120, 16)
    castText:SetPoint("CENTER", castBar, "CENTER", 0, 0)
    plate.castText = castText

    cbicon:ClearAllPoints()
    cbicon:SetPoint("RIGHT", castBar, "LEFT", -4, 0)
    cbicon:SetSize(14, 14)

    border:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
end

local function updatePlate(plate)
    local nameText = plate.oldName:GetText()
    plate.oldName:SetAlpha(0)

    local targetText = nameText
    local isArena = false

    if RougeUI.db.ArenaNumbers and cachedInstanceType == "arena" then
        local unit = unitKeys[nameText]
        local arenaNum = unit and unit:match("^arena(%d)$")
        if arenaNum then
            targetText = arenaNum
            isArena = true
        end
    end

    if plate.lastName ~= targetText then
        plate.lastName = targetText
        plate.newName:SetText(targetText)
    end

    if isArena then
        if not plate.arenaFormatted then
            plate.arenaFormatted = true
            plate.newName:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
            plate.newName:ClearAllPoints()
            plate.newName:SetPoint("BOTTOM", plate, "TOP", 0, -15)
            plate.levelText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        end
    elseif plate.arenaFormatted then
        defaultNames(plate)
    end

    local isOver = plate:IsMouseOver()
    if isOver ~= plate.lastIsOver then
        plate.lastIsOver = isOver
        if isOver then
            if UnitCanAttack("player", "mouseover") then
                plate.newName:SetTextColor(1, 0, 0)
            else
                plate.newName:SetTextColor(1, 0.82, 0)
            end
        else
            plate.newName:SetTextColor(1, 1, 1)
        end
    end

    local cb = plate.castBar
    if cb and plate.castText then
        local cname, texture
        local isChanneling = false
        local hasManualCast = false
        local value, maxValue = 0, 0

        local castUnit = unitKeys[nameText]

        if not castUnit then
            if UnitExists("target") and UnitName("target") == nameText then
                castUnit = "target"
            elseif UnitExists("mouseover") and UnitName("mouseover") == nameText then
                castUnit = "mouseover"
            end
        end

        if castUnit then
            local startTime, endTime
            cname, _, _, texture, startTime, endTime = UnitCastingInfo(castUnit)
            if cname then
                hasManualCast = true
                maxValue = (endTime - startTime) / 1000
                local now = GetTime() * 1000
                value = (now - startTime) / 1000
            else
                cname, _, _, texture, startTime, endTime = UnitChannelInfo(castUnit)
                if cname then
                    hasManualCast = true
                    isChanneling = true
                    maxValue = (endTime - startTime) / 1000
                    local now = GetTime() * 1000
                    value = (endTime - now) / 1000
                end
            end
        end

        if hasManualCast then
            cb:SetMinMaxValues(0, maxValue)
            cb:SetValue(value)

            if not cb:IsShown() then
                cb:Show()
            end

            if plate.cbborder then
                if not plate.cbborderColored then
                    plate.cbborderColored = true
                    plate.cbborder:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
                end
                if not plate.cbborder:IsShown() then
                    plate.cbborder:Show()
                end
            end

            if plate.cbicon and texture then
                plate.cbicon:SetTexture(texture)
                if not plate.cbicon:IsShown() then
                    plate.cbicon:Show()
                end
            end

            if cname and cname ~= plate.lastCastName then
                plate.lastCastName = cname
                plate.castText:SetText(cname)
            end
            if not plate.castText:IsShown() then
                plate.castText:Show()
            end
        else
            if cb:IsShown() then
                cb:Hide()
            end
            if plate.cbborder and plate.cbborder:IsShown() then
                plate.cbborder:Hide()
            end
            if plate.cbicon and plate.cbicon:IsShown() then
                plate.cbicon:Hide()
            end
            if plate.castText:IsShown() then
                plate.lastCastName = nil
                plate.castText:SetText("")
                plate.castText:Hide()
            end
        end
    end
end

local function resetCache()
    wipe(unitKeys)
    local _, instanceType = IsInInstance()
    cachedInstanceType = instanceType or ""
    cachedArenaOpponents = GetNumArenaOpponents() or 0
    for plate in pairs(activePlates) do
        plate.arenaFormatted = false
        plate.lastName = nil
        plate.lastIsOver = nil
        plate.lastCastName = nil
    end
end

local function onUpdate(self, elapsed)
    time = time + elapsed

    local currentChildren = WorldFrame:GetNumChildren()
    if currentChildren ~= numChildren then
        numChildren = currentChildren
        local children = {WorldFrame:GetChildren()}
        for i = 1, currentChildren do
            local plate = children[i]
            if not activePlates[plate] then
                local _, region = plate:GetRegions()
                if region and region:GetObjectType() == "Texture" then
                    local texture = region:GetTexture()
                    if texture == "Interface\\Tooltips\\Nameplate-Border"
                    or texture == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" then
                        activePlates[plate] = true
                        initPlate(plate)
                    end
                end
            end
        end
    end

    if time >= 1 then
        for _, unit in ipairs(trackedUnits) do
            if UnitExists(unit) then
                local name = UnitName(unit)
                if name and not unitKeys[name] then
                    unitKeys[name] = unit
                end
            end
        end
        if cachedInstanceType == "arena" then
            cachedArenaOpponents = GetNumArenaOpponents() or 0
        end
        time = 0
    end

    for plate in pairs(activePlates) do
        if plate:IsShown() then
            updatePlate(plate)
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
        resetCache()
        return
    end

    if not (GetCVarBool("nameplateShowEnemies") or GetCVarBool("nameplateShowFriends")) then
        return
    end

    if RougeUI.db.ModPlates or RougeUI.db.Colval < 1 then
        frame:SetScript("OnUpdate", onUpdate)
    end
end)