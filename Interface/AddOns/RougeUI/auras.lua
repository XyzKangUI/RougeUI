local addonName, RougeUI = ...
local UnitIsUnit, UnitIsOwnerOrControllerOfUnit, UnitIsEnemy = _G.UnitIsUnit, _G.UnitIsOwnerOrControllerOfUnit, _G.UnitIsEnemy
local UnitClass, UnitIsFriend = _G.UnitClass, _G.UnitIsFriend
local mabs, mfloor = math.abs, math.floor
local AURA_OFFSET_Y = 1
local fontName

local Enraged = {
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

local Whitelist = {
    [16188] = true, -- Nature's Swiftness
    [12043] = true, -- Presence of Mind
    [12042] = true, -- Arcane Power
    [12472] = true, -- Icy Veins
    [31884] = true, -- Avenging Wrath
    [48066] = true, -- Power Word: Shield
    [47986] = true, -- Sacrifice
    [43039] = true, -- Ice Barrier
    [22812] = true, -- Barkskin
    [1044] = true, -- Hand of Freedom
    [29166] = true, -- Innervate
    [2825] = true, -- Bloodlust
    [32182] = true, -- Heroism
    [10060] = true, -- Power Infusion
    [33206] = true, -- Pain Suppression
    [53312] = true, -- Nature's Grasp
    [6346] = true, -- Fear Ward
    [6940] = true, -- Hand of Sacrifice
    [10278] = true, -- Blessing of Protection
    [18708] = true, -- Fel Domination
    [45438] = true, -- Ice Block
    [642] = true, -- Divine Shield
    [53601] = true, -- Sacred Shield
    [54428] = true, -- Divine Plea
    [66115] = true, -- Hand of Freedom
    [498] = true, -- Divine Protection
    [53563] = true, -- Beacon of Light
    [63560] = true, -- Ghoul Frenzy
    [31842] = true, -- Divine Illumination
    [57761] = true, -- Fireball!
    [49284] = true, -- Earth Shield
    [69369] = true, -- Predator's Swiftness
    [64701] = true, -- Elemental Mastery
    [44544] = true, -- Fingers of Frost
    [63167] = true, -- Decimation
    [63244] = true, -- Pyroclasm
    [34936] = true, -- Backlash
    [65081] = true, -- Body and Soul
    [54372] = true, -- Nether Protection
}

local whitelistMetatable = {
    __index = function(tbl, key)
        local name = GetSpellInfo(key)
        return name
    end
}
setmetatable(Whitelist, whitelistMetatable)

local function GetFramePosition(frame)
    if not frame then
        return 0, 0, 0
    end

    local left = frame:GetLeft() or 0
    local bottom = frame:GetBottom() or 0
    return left, bottom
end

local function TargetBuffSize(frame, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX)
    local LARGE_AURA_SIZE = RougeUI.db.SelfSize
    local SMALL_AURA_SIZE = RougeUI.db.OtherBuffSize
    local AURA_ROW_WIDTH = RougeUI.db.AuraRow
    local size, biggestAura
    local offsetY = AURA_OFFSET_Y
    local rowWidth = 0
    local firstBuffOnRow = 1
    local haveTargetofTarget = frame.totFrame and frame.totFrame:IsShown()
    local totFrameX, totFrameBottom = GetFramePosition(frame.totFrame)
    local currentX, currentY

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
            if frame.largestAura then
                offsetY = frame.largestAura
            end
        else
            rowWidth = rowWidth + size + offsetX
        end

        local verticalDistance = currentY and (currentY - totFrameBottom) or 0
        local horizontalDistance = rowWidth

        if currentX then
            horizontalDistance = (mfloor(mabs((currentX + size + offsetX) - totFrameX))) + 5 -- Cheat a bit
        end

        if (haveTargetofTarget and (horizontalDistance < size) and verticalDistance > 0) or (rowWidth > maxRowWidth) then
            local anchorAura = _G[auraName .. firstBuffOnRow]
            if biggestAura >= mfloor(anchorAura:GetSize() + 0.5) then
                offsetY = (AURA_OFFSET_Y * 2) + (biggestAura - anchorAura:GetSize())
            end
            updateFunc(frame, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY)
            rowWidth = size
            frame.auraRows = frame.auraRows + 1
            firstBuffOnRow = i
            offsetY = AURA_OFFSET_Y
            biggestAura = nil
            frame.largestAura = nil
        else
            updateFunc(frame, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY)
        end

        if not biggestAura or (biggestAura and (biggestAura < size)) then
            biggestAura = size
        end

        local calc = (AURA_OFFSET_Y * 2) + (biggestAura - _G[auraName .. firstBuffOnRow]:GetSize())
        if not frame.largestAura or (frame.largestAura and (frame.largestAura < calc)) then
            frame.largestAura = calc
        end

        local aura = _G[auraName .. i]
        currentX, currentY = aura:GetLeft(), aura:GetTop()
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

local function New_TargetFrame_UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY)
    --For mirroring vertically
    local point, relativePoint
    local startY, auraOffsetY
    point = "TOP"
    relativePoint = "BOTTOM"
    startY = 32
    auraOffsetY = AURA_OFFSET_Y

    local buff = _G[buffName .. index]
    if (index == 1) then
        if (UnitIsFriend("player", self.unit) or numDebuffs == 0) then
            -- unit is friendly or there are no debuffs...buffs start on top
            buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", 5, startY)
        else
            local _, a = self.debuffs:GetPoint()
            if a then
                local _, b = a:GetPoint()
                if b == self.buffs then
                    self.debuffs:ClearAllPoints()
                    self.debuffs:SetPoint(point .. "LEFT", self, point .. "LEFT", 0, 0)
                    self.debuffs:SetPoint(relativePoint .. "LEFT", self, relativePoint .. "LEFT", 0, -auraOffsetY)
                end
            end
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

local function New_TargetFrame_UpdateDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY)
    local buff = _G[debuffName .. index]
    local isFriend = UnitIsFriend("player", self.unit)

    --For mirroring vertically
    local point, relativePoint
    local startY, auraOffsetY
    point = "TOP"
    relativePoint = "BOTTOM"
    startY = 32
    auraOffsetY = AURA_OFFSET_Y

    if (index == 1) then
        if (isFriend and numBuffs > 0) then
            -- unit is friendly and there are buffs...debuffs start on bottom
            buff:SetPoint(point .. "LEFT", self.buffs, relativePoint .. "LEFT", 0, -offsetY)
        else
            -- unit is not friendly or there are no buffs...debuffs start on top
            buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", 5, startY)
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
        if UnitIsUnit(caster, token) then
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
    local playerIsTarget = UnitIsUnit("player", frame.unit)

    for i = 1, 32 do
        local name, _, icon, _, debuffType, _, _, caster, isStealable, _, spellId = UnitBuff(frame.unit, i, "HELPFUL")
        if (name) then
            frameName = selfName .. "Buff" .. (i)
            buffFrame = _G[frameName]

            if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
                local showHighlight = false
                local r, g, b = 1, 1, 1
                local modifier = 1.2

                if RougeUI.db.Lorti or RougeUI.db.Roug or RougeUI.db.Modern then
                    r, g, b = 1, 1, 0.75
                    modifier = 2.2
                end

                if RougeUI.db.HighlightDispellable then
                    if isEnemy then
                        if Whitelist[name] and isStealable then
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
                        end
                    end
                elseif isEnemy and isStealable and not RougeUI.db.HighlightDispellable then
                    showHighlight = true
                end

                local largeSize = ShouldAuraBeLarge(caster)
                local buffSize = RougeUI.db.OtherBuffSize

                if largeSize then
                    buffSize = RougeUI.db.SelfSize
                end

                local frameStealable = _G[frameName .. "Stealable"]
                if showHighlight then
                    frameStealable:Show()
                    frameStealable:SetHeight(buffSize * modifier)
                    frameStealable:SetWidth(buffSize * modifier)
                    frameStealable:SetVertexColor(r, g, b)
                    if modifier == 2.2 then
                        frameStealable:SetDesaturated(true)
                    end
                else
                    frameStealable:Hide()
                end

                frameCount = _G[frameName .. "Count"]
                if frameCount then
                    if not fontName then
                        fontName = frameCount:GetFont()
                    end
                    frameCount:SetFont(fontName, buffSize / 1.75, "OUTLINE, THICKOUTLINE, MONOCHROME")
                end

                -- set the buff to be big if the buff is cast by the player or his pet
                numBuffs = numBuffs + 1
                largeBuffList[numBuffs] = largeSize
            end
        else
            break
        end
    end

    local numDebuffs = 0

    local frameNum = 1
    local index = 1

    local maxDebuffs = frame.maxDebuffs or 16
    while (frameNum <= maxDebuffs and index <= maxDebuffs) do
        local debuffName, _, icon, count, debuffType, duration, expirationTime, caster, _, _, spellId = UnitDebuff(frame.unit, index, "INCLUDE_NAME_PLATE_ONLY")
        if (debuffName) then
            --if (TargetFrame_ShouldShowDebuffs(frame.unit, caster, nameplateShowAll, casterIsPlayer)) then
            frameName = selfName .. "Debuff" .. frameNum
            buffFrame = _G[frameName]
            if (icon) then

                local largeSize = ShouldAuraBeLarge(caster)

                frameCount = _G[frameName .. "Count"]
                if frameCount then
                    if not fontName then
                        fontName = frameCount:GetFont()
                    end
                    local buffSize = largeSize and RougeUI.db.SelfSize or RougeUI.db.OtherBuffSize
                    frameCount:SetFont(fontName, buffSize / 1.75, "OUTLINE, THICKOUTLINE, MONOCHROME")
                end

                -- set the debuff to be big if the buff is cast by the player or his pet
                numDebuffs = numDebuffs + 1
                largeDebuffList[numDebuffs] = largeSize
                frameNum = frameNum + 1
                -- end
            end
        else
            break
        end
        index = index + 1
    end

    frame.auraRows = 0
    frame.largestAura = 0

    local maxRowWidth = RougeUI.db.AuraRow

    frame.spellbarAnchor = nil

    if isEnemy then
        TargetBuffSize(frame, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, 3)
        TargetBuffSize(frame, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, 3)
    else
        TargetBuffSize(frame, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, 3)
        TargetBuffSize(frame, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, 3)
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
        hooksecurefunc("TargetFrame_UpdateAuras", Target_Update)
        hooksecurefunc("Target_Spellbar_AdjustPosition", New_Target_Spellbar_AdjustPosition)
    end
end

local FF = CreateFrame("Frame")
FF:RegisterEvent("PLAYER_LOGIN")
FF:SetScript("OnEvent", function(self, fireEvent)
    if fireEvent == "PLAYER_LOGIN" then
        if RougeUI.db.BuffSizer or RougeUI.db.HighlightDispellable then
            RougeUI.RougeUIF:HookAuras()
        end
    end
end)