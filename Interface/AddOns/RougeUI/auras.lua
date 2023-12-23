local _, RougeUI = ...
local AURA_OFFSET_Y = 1
local AURA_START_X = 5
local AURA_START_Y = 32
local OFFSET_X = 3
local GetSpellInfo, hooksecurefunc, UnitIsFriend = _G.GetSpellInfo, _G.hooksecurefunc, _G.UnitIsFriend
local UnitIsUnit, UnitIsOwnerOrControllerOfUnit, UnitIsEnemy, UnitClass = _G.UnitIsUnit, _G.UnitIsOwnerOrControllerOfUnit, _G.UnitIsEnemy, _G.UnitClass
local UnitBuff, UnitDebuff = _G.UnitBuff, _G.UnitDebuff
local pairs = _G.pairs
local MAX_TARGET_DEBUFFS = 16
local MAX_TARGET_BUFFS = 32
local mabs, mfloor = math.abs, math.floor
local WOW_PROJECT_ID, WOW_PROJECT_CLASSIC = WOW_PROJECT_ID, WOW_PROJECT_CLASSIC
local Enraged, Whitelist = {}, {}
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
local isClassic
local LibClassicDurations

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
    Enraged = {
        --    [5229] = true, -- Enrage (Druid)
        [1719] = true, -- Recklessness
        --    [12880] = true, -- Enrage (npc)
        --    [14204] = true, -- Enrage (npc)
        --    [14202] = true, -- Enrage (npc)
        --    [14203] = true, -- Enrage (npc)
        --    [14201] = true, -- Enrage (npc)
        [18499] = true, -- Berseker Rage
        --    [12292] = true, -- Death Wish
        --    [2687] = true, -- Bloodrage
        --    [29131] = true, -- Bloodrage
        [48391] = true, -- Owlkin Frenzy
        [49016] = true, -- Unholy Frenzy
        [50636] = true, -- Tormented Roar (npc)
        --    [51662] = true, -- Hunger for blood
        [54508] = true, -- Demonic Empowerment
        --    [57514] = true, -- Enrage (npc)
        --    [57516] = true, -- Enrage
        --    [57518] = true, -- Enrage
        --    [57519] = true, -- Enrage
        --    [57520] = true, -- Enrage
        --    [57522] = true, -- Enrage
        [63147] = true, -- Sara's Anger (npc)
        [66759] = true, -- Frothing Rage (npc)
        [62071] = true, -- Savage Roar
        --    [51513] = true, -- Enrage
        [60177] = true, -- Hfb (npc)
        --    [57521] = true, -- Enrage
        [63848] = true, -- Hfb (npc)
        [52610] = true, -- Savage roar
        [66759] = true, -- Frothing Rage
    }

    Whitelist = {
        [GetSpellInfo(16188)] = true, -- Nature's Swiftness
        [GetSpellInfo(12043)] = true, -- Presence of Mind
        [GetSpellInfo(12042)] = true, -- Arcane Power
        [GetSpellInfo(12472)] = true, -- Icy Veins
        [GetSpellInfo(31884)] = true, -- Avenging Wrath
        [GetSpellInfo(48066)] = true, -- Power Word: Shield
        [GetSpellInfo(47986)] = true, -- Sacrifice
        [GetSpellInfo(43039)] = true, -- Ice Barrier
        [GetSpellInfo(22812)] = true, -- Barkskin
        [GetSpellInfo(1044)] = true, -- Hand of Freedom
        [GetSpellInfo(29166)] = true, -- Innervate
        [GetSpellInfo(2825)] = true, -- Bloodlust
        [GetSpellInfo(32182)] = true, -- Heroism
        [GetSpellInfo(10060)] = true, -- Power Infusion
        [GetSpellInfo(33206)] = true, -- Pain Supression
        [GetSpellInfo(53312)] = true, -- Nature's Grasp
        [GetSpellInfo(6346)] = true, -- Fear Ward
        [GetSpellInfo(6940)] = true, -- Hand of Sacrifice
        [GetSpellInfo(10278)] = true, -- Blessing of Protection
        [GetSpellInfo(18708)] = true, -- Fel Domination
        [GetSpellInfo(45438)] = true, -- Ice Block
        [GetSpellInfo(642)] = true, -- Divine Shield
        [GetSpellInfo(53601)] = true, -- Sacred Shield
        [GetSpellInfo(54428)] = true, -- Divine Plea
        [GetSpellInfo(66115)] = true, -- Hand of Freedom
        [GetSpellInfo(498)] = true, -- Divine Protection
        [GetSpellInfo(53563)] = true, -- Beacon of Light
        [GetSpellInfo(63560)] = true, -- Ghoul Frenzy
        [GetSpellInfo(31842)] = true, -- Divine illumination
        [GetSpellInfo(57761)] = true, -- Fireball!
        [GetSpellInfo(49284)] = true, -- Earth Shield
        [GetSpellInfo(69369)] = true, -- Predator's Swiftness
        [GetSpellInfo(64701)] = true, -- Elemental Mastery
        [GetSpellInfo(44544)] = true, -- Fingers of frost
        [GetSpellInfo(63167)] = true, -- Decimation
        [GetSpellInfo(63244)] = true, -- Pyroclasm
        [GetSpellInfo(34936)] = true, -- Backlash
        [GetSpellInfo(65081)] = true, -- Body and Soul
        [GetSpellInfo(54372)] = true, -- Nether Protection

    }
end

local function RealWidth(frame, auraName, width)
    if not (frame.totFrame == _G.TargetFrameToT or frame.totFrame == _G.FocusFrameToT) then
        return
    end

    local x1 = frame.totFrame:GetLeft()
    local x2 = _G[auraName .. "1"]:GetLeft()
    if not x1 or not x2 then
        return frame.TOT_AURA_ROW_WIDTH
    end

    local diff = mabs(x2 - x1)
    local distance = mfloor(diff) + 2 -- cheat a bit

    if distance > 136 then
        -- let user regulate when ToTo is in Africa
        return width
    else
        return distance
    end
end

local function maxRows(self, width, mirror, auraName)
    local haveTargetofTarget

    if self.totFrame ~= nil then
        haveTargetofTarget = self.totFrame:IsShown()
    end

    if (haveTargetofTarget and self.auraRows <= 2) and not mirror then
        return RealWidth(self, auraName, width)
    else
        return width
    end
end

local function TargetBuffSize(frame, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX, mirrorAurasVertically)
    local LARGE_AURA_SIZE = RougeUI.db.SelfSize
    local SMALL_AURA_SIZE = RougeUI.db.OtherBuffSize
    local AURA_ROW_WIDTH = RougeUI.db.AuraRow
    local size
    local offsetY = AURA_OFFSET_Y
    local rowWidth = 0
    local firstBuffOnRow = 1

    maxRowWidth = AURA_ROW_WIDTH

    for i = 1, numAuras do
        if (largeAuraList[i]) then
            size = LARGE_AURA_SIZE
            offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y
        else
            size = SMALL_AURA_SIZE
        end

        if (i == 1) then
            rowWidth = size
            frame.auraRows = frame.auraRows + 1
        else
            rowWidth = rowWidth + size + offsetX
        end

        if (rowWidth > maxRows(frame, maxRowWidth, mirrorAurasVertically, auraName)) then
            updateFunc(frame, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically)
            rowWidth = size
            frame.auraRows = frame.auraRows + 1
            firstBuffOnRow = i
            offsetY = AURA_OFFSET_Y
        else
            updateFunc(frame, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically)
        end
    end
end

local function New_Target_Spellbar_AdjustPosition(self)
    local parentFrame = self:GetParent()
    if (self.boss) then
        self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, 10)
    elseif (parentFrame.haveToT) then
        if (parentFrame.buffsOnTop or parentFrame.auraRows <= 1) then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -25)
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        end
    elseif (parentFrame.haveElite) then
        if (parentFrame.buffsOnTop or parentFrame.auraRows <= 1) then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -5)
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        end
    else
        if ((not parentFrame.buffsOnTop) and parentFrame.auraRows > 0) then
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        else
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, 7)
        end
    end
end

local function New_TargetFrame_UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    --For mirroring vertically
    local point, relativePoint
    local startY, auraOffsetY
    if (mirrorVertically) then
        point = "BOTTOM"
        relativePoint = "TOP"
        startY = -9
        offsetY = -offsetY
        auraOffsetY = -AURA_OFFSET_Y
    else
        point = "TOP"
        relativePoint = "BOTTOM"
        startY = AURA_START_Y
        auraOffsetY = AURA_OFFSET_Y
    end

    local buff = _G[buffName .. index]
    if (index == 1) then
        if (UnitIsFriend("player", self.unit) or numDebuffs == 0) then
            -- unit is friendly or there are no debuffs...buffs start on top
            buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", AURA_START_X, startY)
        else
            -- unit is not friendly and we have debuffs...buffs start on bottom
            buff:SetPoint(point .. "LEFT", self.debuffs, relativePoint .. "LEFT", 0, -offsetY)
        end
        self.buffs:SetPoint(point .. "LEFT", buff, point .. "LEFT", 0, 0)
        self.buffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
        self.spellbarAnchor = buff
    elseif (anchorIndex ~= (index - 1)) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint(point .. "LEFT", _G[buffName .. anchorIndex], relativePoint .. "LEFT", 0, -offsetY)
        self.buffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
        self.spellbarAnchor = buff
    else
        -- anchor index is the previous index
        buff:SetPoint(point .. "LEFT", _G[buffName .. anchorIndex], point .. "RIGHT", offsetX, 0)
    end

    -- Resize
    buff:SetWidth(size)
    buff:SetHeight(size)
end

local function New_TargetFrame_UpdateDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local buff = _G[debuffName .. index]
    local isFriend = UnitIsFriend("player", self.unit)

    --For mirroring vertically
    local point, relativePoint
    local startY, auraOffsetY
    if (mirrorVertically) then
        point = "BOTTOM"
        relativePoint = "TOP"
        startY = -15
        offsetY = -offsetY
        auraOffsetY = -AURA_OFFSET_Y
    else
        point = "TOP"
        relativePoint = "BOTTOM"
        startY = AURA_START_Y
        auraOffsetY = AURA_OFFSET_Y
    end

    if (index == 1) then
        if (isFriend and numBuffs > 0) then
            -- unit is friendly and there are buffs...debuffs start on bottom
            buff:SetPoint(point .. "LEFT", self.buffs, relativePoint .. "LEFT", 0, -offsetY)
        else
            -- unit is not friendly or there are no buffs...debuffs start on top
            buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", AURA_START_X, startY)
        end
        self.debuffs:SetPoint(point .. "LEFT", buff, point .. "LEFT", 0, 0)
        self.debuffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
        if ((isFriend) or (not isFriend and numBuffs == 0)) then
            self.spellbarAnchor = buff
        end
    elseif (anchorIndex ~= (index - 1)) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint(point .. "LEFT", _G[debuffName .. anchorIndex], relativePoint .. "LEFT", 0, -offsetY)
        self.debuffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
        if ((isFriend) or (not isFriend and numBuffs == 0)) then
            self.spellbarAnchor = buff
        end
    else
        -- anchor index is the previous index
        buff:SetPoint(point .. "LEFT", _G[debuffName .. (index - 1)], point .. "RIGHT", offsetX, 0)
    end

    -- Resize
    buff:SetWidth(size)
    buff:SetHeight(size)
    local debuffFrame = _G[debuffName .. index .. "Border"]
    debuffFrame:SetWidth(size + 2)
    debuffFrame:SetHeight(size + 2)
end

local largeBuffList = {}
local largeDebuffList = {}
local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true,
}

local function ShouldAuraBeLarge(caster)
    if not caster then
        return false
    end

    for token, value in pairs(PLAYER_UNITS) do
        if UnitIsUnit(caster, token) or UnitIsOwnerOrControllerOfUnit(token, caster) then
            return value
        end
    end
end

local function Target_Update(frame)
    if not (frame == TargetFrame or frame == FocusFrame) then
        return
    end

    local buffFrame, frameName
    local frameIcon, frameCount, frameCooldown
    local numBuffs = 0
    local selfName = frame:GetName()
    local isEnemy = UnitIsEnemy("player", frame.unit)
    local _, _, class = UnitClass("player")

    for i = 1, MAX_TARGET_BUFFS do
        local name, icon, count, _, duration, expirationTime, caster, isStealable, spellId
        if isClassic then
            name, icon, count, _, duration, expirationTime, caster, isStealable, _, spellId = LibClassicDurations:UnitAura(frame.unit, i, "HELPFUL")
        else
            name, icon, _, _, _, _, caster, isStealable, _, spellId = UnitBuff(frame.unit, i, "HELPFUL")
        end
        if (name) then
            frameName = selfName .. "Buff" .. (i)
            buffFrame = _G[frameName]

            if isClassic then
                if (not buffFrame) then
                    if (not icon) then
                        break 
                    else
                        buffFrame = CreateFrame("Button", frameName, frame, "TargetBuffFrameTemplate")
                        buffFrame.unit = frame.unit
                    end
                end
            end

            if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
                if isClassic then
                    buffFrame:SetID(i)

                    -- set the icon
                    frameIcon = _G[frameName .. "Icon"]
                    frameIcon:SetTexture(icon)

                    -- set the count
                    frameCount = _G[frameName .. "Count"]
                    if (count > 1 and frame.showAuraCount) then
                        frameCount:SetText(count)
                        frameCount:Show()
                    else
                        frameCount:Hide()
                    end

                    -- Handle cooldowns
                    frameCooldown = _G[frameName .. "Cooldown"]
                    local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(frame.unit, spellId, caster)
                    if duration == 0 and durationNew then
                        duration = durationNew
                        expirationTime = expirationTimeNew
                    end
                    CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true)

                end

                local showHighlight = false
                local r, g, b = 1, 1, 1

                if RougeUI.db.HighlightDispellable and (WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC) then
                    if isEnemy then
                        if Whitelist[name] and isStealable then
                            r, g, b = 1, 1, 1 -- White
                            showHighlight = true
                        elseif (class == 4 or class == 3) and Enraged[spellId] then
                            r, g, b = 1, 0, 0 -- Red
                            showHighlight = true
                        elseif spellId == 31821 then
                            r, g, b = 0, 0, 1 -- Blue
                            showHighlight = true
                        elseif spellId == 49039 and (class == 5 or class == 2) then
                            r, g, b = 1, 0, 127 / 255 -- Pink
                            showHighlight = true
                        elseif spellId == 53659 then
                            r, g, b = 52 / 255, 235 / 255, 146 / 255 -- Green
                            showHighlight = true
                        end
                    end
                elseif (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and RougeUI.db.HighlightDispellable and isEnemy then
                    showHighlight = true
                elseif isEnemy and isStealable and not RougeUI.db.HighlightDispellable then
                    showHighlight = true
                end

                local largeSize = ShouldAuraBeLarge(caster)
                local frameStealable = _G[frameName .. "Stealable"]
                if showHighlight then
                    local buffSize = RougeUI.db.OtherBuffSize
                    if largeSize then
                        buffSize = RougeUI.db.SelfSize
                    end
                    frameStealable:Show()
                    frameStealable:SetHeight(buffSize * 1.24)
                    frameStealable:SetWidth(buffSize * 1.24)
                    frameStealable:SetVertexColor(r, g, b)
                else
                    frameStealable:Hide()
                end

                -- set the buff to be big if the buff is cast by the player or his pet
                numBuffs = numBuffs + 1
                largeBuffList[numBuffs] = largeSize

                if isClassic then
                    buffFrame:ClearAllPoints()
                    buffFrame:Show()
                end
            else
                if isClassic then
                    buffFrame:Hide()
                end
            end
        else
            break 
        end
    end

    local numDebuffs = 0

    local frameNum = 1
    local index = 1

    local maxDebuffs = frame.maxDebuffs or MAX_TARGET_DEBUFFS
    while (frameNum <= maxDebuffs and index <= maxDebuffs) do
        local debuffName, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _, _, casterIsPlayer, nameplateShowAll = UnitDebuff(frame.unit, index, "INCLUDE_NAME_PLATE_ONLY")
        if (debuffName) then
            if (TargetFrame_ShouldShowDebuffs(frame.unit, caster, nameplateShowAll, casterIsPlayer)) then
                frameName = selfName .. "Debuff" .. frameNum
                buffFrame = _G[frameName]
                if (icon) then
                    -- set the debuff to be big if the buff is cast by the player or his pet
                    numDebuffs = numDebuffs + 1
                    largeDebuffList[numDebuffs] = ShouldAuraBeLarge(caster)
                    frameNum = frameNum + 1
                end
            end
        else
            break 
        end
        index = index + 1
    end

    frame.auraRows = 0

    local mirrorAurasVertically = false
    if (frame.buffsOnTop) then
        mirrorAurasVertically = true
    end

    frame.spellbarAnchor = nil
    local maxRowWidth = RougeUI.db.AuraRow
    if (UnitIsFriend("player", frame.unit)) then
        -- update buff positions
        TargetBuffSize(frame, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, OFFSET_X, mirrorAurasVertically)
        -- update debuff positions
        TargetBuffSize(frame, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, OFFSET_X, mirrorAurasVertically)
    else
        -- update debuff positions
        TargetBuffSize(frame, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, OFFSET_X, mirrorAurasVertically)
        -- update buff positions
        TargetBuffSize(frame, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, OFFSET_X, mirrorAurasVertically)
    end
    -- update the spell bar position
    if (frame.spellbar) then
        New_Target_Spellbar_AdjustPosition(frame.spellbar)
    end
end

function RougeUI.RougeUIF:SetCustomBuffSize()
    local frames = {
        TargetFrame,
        FocusFrame
    }

    for _, frame in pairs(frames) do
        TargetFrame_UpdateAuras(frame)
    end
end

function RougeUI.RougeUIF:HookAuras()
    if not IsAddOnLoaded("DeBuffFilter") then
        -- hooksecurefunc("TargetFrame_UpdateAuraPositions", TargetBuffSize)
        hooksecurefunc("Target_Spellbar_AdjustPosition", New_Target_Spellbar_AdjustPosition)
        hooksecurefunc("TargetFrame_UpdateAuras", Target_Update)
    end
end

local FF = CreateFrame("Frame")
FF:RegisterEvent("PLAYER_LOGIN")
FF:SetScript("OnEvent", function(self)
    if RougeUI.db.BuffSizer or RougeUI.db.HighlightDispellable then
        RougeUI.RougeUIF:HookAuras()
        isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and IsAddOnLoaded("LibClassicDurations")
        if isClassic then
            LibClassicDurations = LibStub("LibClassicDurations")
            LibClassicDurations:Register("RougeUI")
            LibClassicDurations.RegisterCallback(RougeUI, "UNIT_BUFF", function(event, unit)
                TargetFrame_UpdateAuras(TargetFrame)
            end)
        end
    end

    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)