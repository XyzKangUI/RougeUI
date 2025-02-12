local addonName, RougeUI = ...
local UnitIsUnit, UnitIsOwnerOrControllerOfUnit, UnitIsEnemy = _G.UnitIsUnit, _G.UnitIsOwnerOrControllerOfUnit, _G.UnitIsEnemy
local UnitBuff, UnitDebuff = _G.UnitBuff, _G.UnitDebuff
local UnitClass, UnitIsFriend = _G.UnitClass, _G.UnitIsFriend
local mabs, mfloor = math.abs, math.floor
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local AURA_OFFSET_Y = 1
local fontName
local xPosOffset = 5

local Enraged = {
    --[5229] = true, -- Enrage (Druid)
    [1719] = true, -- Recklessness
    [12880] = true, -- Enrage
    --[14204] = true, -- Enrage (npc)
    --[14202] = true, -- Enrage (npc)
    --[14203] = true, -- Enrage (npc)
    --[14201] = true, -- Enrage (npc)
    [18499] = true, -- Berseker Rage
    [12292] = true, -- Death Wish
    --[2687] = true, -- Bloodrage
    --[29131] = true, -- Bloodrage
    [48391] = true, -- Owlkin Frenzy
    [49016] = true, -- Unholy Frenzy
    [50636] = true, -- Tormented Roar (npc)
    --[51662] = true, -- Hunger for blood
    [54508] = true, -- Demonic Empowerment
    [57514] = true, -- Enrage
    --[57516] = true, -- Enrage
    [57518] = true, -- Enrage
    [57519] = true, -- Enrage
    --[57520] = true, -- Enrage
    --[57522] = true, -- Enrage
    [63147] = true, -- Sara's Anger (npc)
    [66759] = true, -- Frothing Rage (npc)
    [62071] = true, -- Savage Roar
    --[51513] = true, -- Enrage
    [60177] = true, -- Hfb (npc)
    --[57521] = true, -- Enrage
    [63848] = true, -- Hfb (npc)
    [52610] = true, -- Savage roar
    [66759] = true, -- Frothing Rage
    [81017] = true, -- Stampede
    [81022] = true, -- Stampede
    [81016] = true, -- Stampede
    [81021] = true, -- Stampede
    [77238] = true, -- Charged Fists
    [69052] = true, -- Unholy Frenzy
    [55462] = true, -- Storm's Fury
    [76691] = true, -- Vengeance
    [91668] = true, -- Unstable Strength
    [81772] = true, -- Overtime
}

local Whitelist = {
    [16188] = true, -- Nature's Swiftness
    [12043] = true, -- Presence of Mind
    [12042] = true, -- Arcane Power
    [12472] = true, -- Icy Veins
    [31884] = true, -- Avenging Wrath
    [17] = true, -- Power Word: Shield
    [7812] = true, -- Sacrifice
    [22812] = true, -- Barkskin
    [1044] = true, -- Hand of Freedom
    [29166] = true, -- Innervate
    [2825] = true, -- Bloodlust
    [32182] = true, -- Heroism
    [10060] = true, -- Power Infusion
    [33206] = true, -- Pain Supression
    [16689] = true, -- Nature's Grasp
    [6346] = true, -- Fear Ward
    [6940] = true, -- Hand of Sacrifice
    [1022] = true, -- Blessing of Protection
    [18708] = true, -- Fel Domination
    [45438] = true, -- Ice Block
    [642] = true, -- Divine Shield
    [96263] = true, -- Sacred Shield
    [54428] = true, -- Divine Plea
    [66115] = true, -- Hand of Freedom
    [31842] = true, -- Divine Favor
    [57761] = true, -- Fireball!
    [974] = true, -- Earth Shield
    [69369] = true, -- Predator's Swiftness
    [64701] = true, -- Elemental Mastery
    [63167] = true, -- Decimation
    [34936] = true, -- Backlash
    [65081] = true, -- Body and Soul
    [54372] = true, -- Nether Protection
    [80353] = true, -- Time Warp
    [85767] = true, -- Dark Intent
    [90355] = true, -- Ancient Hysteria
    [79462] = true, -- Demon Soul: Felguard
    [79459] = true, -- Demon Soul: Imp
    [79460] = true, -- Demon Soul: Felhnter
    [79464] = true, -- Demon Soul: Voidwalker
    [79463] = true, -- Demon Soul: Succubus
    [81700] = true, -- Archangel
    [87153] = true, -- Dark Archangel
    [79206] = true, -- Spiritwalker's Grace
    [96267] = true, -- Strength Of Soul
    [93400] = true, -- Shooting Stars
    [98864] = true, -- Ice Barrier
    [91711] = true, -- Nether Ward
    [80341] = true, -- Ignite Flesh
    [79967] = true, -- Holy Shield
    [83559] = true, -- Posthaste
    [73718] = true, -- Conductivity
    [76591] = true, -- Aura of Arcane Haste
    [84469] = true, -- Fel Immolate
    [88023] = true, -- Shroud of Gold
    [96844] = true, -- Frostburn Formula
    [74372] = true, -- Veil Sky
    [83567] = true, -- Sparkling Sands
    [85521] = true, -- Vile Aegis
    [91624] = true, -- Enhance Magic
    [76061] = true, -- Dark Blessing
    [100394] = true, -- Draw Magic
    [102259] = true, -- Sheen of Elune
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
        return 0, 0
    end
    return frame:GetLeft() or 0, frame:GetBottom() or 0
end

local function TargetBuffSize(frame, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX, mirrorAurasVertically)
    local db = RougeUI.db
    local LARGE_AURA_SIZE = db.SelfSize
    local SMALL_AURA_SIZE = db.OtherBuffSize
    local AURA_ROW_WIDTH = db.AuraRow
    maxRowWidth = AURA_ROW_WIDTH

    local size, biggestAura
    local offsetY = AURA_OFFSET_Y
    local rowWidth = 0
    local firstBuffOnRow = 1
    local totFrame = frame.totFrame
    local haveTargetofTarget = totFrame and totFrame:IsShown()
    local totFrameX, totFrameBottom = GetFramePosition(totFrame)
    local currentX, currentY

    for i = 1, numAuras do
        if largeAuraList[i] then
            size = LARGE_AURA_SIZE
            offsetY = AURA_OFFSET_Y * 2
        else
            size = SMALL_AURA_SIZE
        end

        if i == 1 then
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
            horizontalDistance = mfloor(mabs((currentX + size + offsetX) - totFrameX)) + 5
        end

        if (haveTargetofTarget and (horizontalDistance < size) and verticalDistance > 0) or (rowWidth > maxRowWidth) then
            local anchorAura = _G[auraName .. firstBuffOnRow]
            if biggestAura and (biggestAura >= mfloor(anchorAura:GetSize() + 0.5)) then
                offsetY = (AURA_OFFSET_Y * 2) + (biggestAura - anchorAura:GetSize())
            end
            updateFunc(frame, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically)
            rowWidth = size
            frame.auraRows = frame.auraRows + 1
            firstBuffOnRow = i
            offsetY = AURA_OFFSET_Y
            biggestAura = nil
            frame.largestAura = nil
        else
            updateFunc(frame, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically)
        end

        if not biggestAura or (biggestAura < size) then
            biggestAura = size
        end

        local calc = (AURA_OFFSET_Y * 2) + (biggestAura - _G[auraName .. firstBuffOnRow]:GetSize())
        if not frame.largestAura or (frame.largestAura < calc) then
            frame.largestAura = calc
        end

        local aura = _G[auraName .. i]
        currentX, currentY = aura:GetLeft(), aura:GetTop()
    end
end

local function New_Target_Spellbar_AdjustPosition(self)
    local parentFrame = self:GetParent()
    if self.boss then
        self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, 10)
    elseif parentFrame.haveToT then
        if parentFrame.buffsOnTop or parentFrame.auraRows <= 1 then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -25)
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        end
    elseif parentFrame.haveElite then
        if parentFrame.buffsOnTop or parentFrame.auraRows <= 1 then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -5)
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        end
    else
        if (not parentFrame.buffsOnTop) and (parentFrame.auraRows > 0) then
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        else
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, 7)
        end
    end
end

local function New_TargetFrame_UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local point, relativePoint, startY, auraOffsetY
    if mirrorVertically then
        point = "BOTTOM"
        relativePoint = "TOP"
        startY = -9
        offsetY = -offsetY
        auraOffsetY = -AURA_OFFSET_Y
    else
        point = "TOP"
        relativePoint = "BOTTOM"
        startY = 32
        auraOffsetY = AURA_OFFSET_Y
    end

    local buff = _G[buffName .. index]
    if index == 1 then
        if UnitIsFriend("player", self.unit) or numDebuffs == 0 then
            buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", xPosOffset, startY)
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
            buff:SetPoint(point .. "LEFT", self.debuffs, relativePoint .. "LEFT", 0, -offsetY)
        end
        self.buffs:SetPoint(point .. "LEFT", buff, point .. "LEFT", 0, 0)
        self.buffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
        self.spellbarAnchor = buff
    elseif anchorIndex ~= (index - 1) then
        buff:SetPoint(point .. "LEFT", _G[buffName .. anchorIndex], relativePoint .. "LEFT", 0, -offsetY)
        self.buffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
        self.spellbarAnchor = buff
    else
        buff:SetPoint(point .. "LEFT", _G[buffName .. anchorIndex], point .. "RIGHT", offsetX, 0)
    end

    buff:SetWidth(size)
    buff:SetHeight(size)
end

local function New_TargetFrame_UpdateDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local point, relativePoint, startY, auraOffsetY
    if mirrorVertically then
        point = "BOTTOM"
        relativePoint = "TOP"
        startY = -15
        offsetY = -offsetY
        auraOffsetY = -AURA_OFFSET_Y
    else
        point = "TOP"
        relativePoint = "BOTTOM"
        startY = 32
        auraOffsetY = AURA_OFFSET_Y
    end

    local buff = _G[debuffName .. index]
    local isFriend = UnitIsFriend("player", self.unit)

    if index == 1 then
        if isFriend and numBuffs > 0 then
            buff:SetPoint(point .. "LEFT", self.buffs, relativePoint .. "LEFT", 0, -offsetY)
        else
            buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", xPosOffset, startY)
        end
        self.debuffs:SetPoint(point .. "LEFT", buff, point .. "LEFT", 0, 0)
        self.debuffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
        if isFriend or (not isFriend and numBuffs == 0) then
            self.spellbarAnchor = buff
        end
    elseif anchorIndex ~= (index - 1) then
        buff:SetPoint(point .. "LEFT", _G[debuffName .. anchorIndex], relativePoint .. "LEFT", 0, -offsetY)
        self.debuffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
        if isFriend or (not isFriend and numBuffs == 0) then
            self.spellbarAnchor = buff
        end
    else
        buff:SetPoint(point .. "LEFT", _G[debuffName .. (index - 1)], point .. "RIGHT", offsetX, 0)
    end

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

    local db = RougeUI.db
    local selfName = frame:GetName()
    local isEnemy = UnitIsEnemy("player", frame.unit)
    local _, _, class = UnitClass("player")
    local fontName

    local numBuffs = 0
    for i = 1, 32 do
        local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, _, spellId = UnitBuff(frame.unit, i, "HELPFUL")
        if not name then
            break
        end

        local frameName = selfName .. "Buff" .. i
        local buffFrame = _G[frameName]

        if icon and (not frame.maxBuffs or i <= frame.maxBuffs) then
            local showHighlight = false
            local r, g, b = 1, 1, 1
            local modifier = 1.2
            if db.Lorti or db.Roug or db.Modern then
                r, g, b = 1, 1, 0.75
                modifier = 2.2
            end

            if db.HighlightDispellable then
                if isEnemy then
                    if Whitelist[name] and isStealable then
                        showHighlight = true
                    elseif (class == 4 or class == 3) and Enraged[spellId] then
                        r, g, b = 1, 0, 0
                        showHighlight = true
                    elseif spellId == 31821 then
                        r, g, b = 0, 0, 1
                        showHighlight = true
                    elseif spellId == 49039 and (class == 5 or class == 2) then
                        r, g, b = 1, 0, 127 / 255
                        showHighlight = true
                    end
                end
            elseif isEnemy and isStealable and not db.HighlightDispellable then
                showHighlight = true
            end

            local largeSize = ShouldAuraBeLarge(caster)
            local buffSize = largeSize and db.SelfSize or db.OtherBuffSize

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

            local frameCount = _G[frameName .. "Count"]
            if frameCount then
                if not fontName then
                    fontName = frameCount:GetFont()
                end
                frameCount:SetFont(fontName, buffSize / 1.75, "OUTLINE, THICKOUTLINE, MONOCHROME")
            end

            numBuffs = numBuffs + 1
            largeBuffList[numBuffs] = largeSize
        end
    end

    local numDebuffs = 0
    local frameNum = 1
    local index = 1
    local maxDebuffs = frame.maxDebuffs or 16
    while frameNum <= maxDebuffs and index <= maxDebuffs do
        local debuffName, icon, count, debuffType, duration, expirationTime, caster, _, _, spellId, _, _, casterIsPlayer, nameplateShowAll = UnitDebuff(frame.unit, index, "INCLUDE_NAME_PLATE_ONLY")
        if not debuffName then
            break
        end
        if TargetFrame_ShouldShowDebuffs(frame.unit, caster, nameplateShowAll, casterIsPlayer) then
            local frameName = selfName .. "Debuff" .. frameNum
            local buffFrame = _G[frameName]
            if icon then
                local guid = caster and UnitGUID(caster) or nil
                if spellId == 88611 and RougeUI.bombExpireTime and guid then
                    duration = RougeUI.bombExpireTime[guid] and 6 or 0
                    expirationTime = RougeUI.bombExpireTime[guid] or 0
                    local frameCooldown = _G[frameName .. "Cooldown"]
                    CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true)
                end

                local largeSize = ShouldAuraBeLarge(caster)
                local frameCount = _G[frameName .. "Count"]
                if frameCount then
                    if not fontName then
                        fontName = frameCount:GetFont()
                    end
                    local buffSize = largeSize and db.SelfSize or db.OtherBuffSize
                    frameCount:SetFont(fontName, buffSize / 1.75, "OUTLINE, THICKOUTLINE, MONOCHROME")
                end

                numDebuffs = numDebuffs + 1
                largeDebuffList[numDebuffs] = largeSize
                frameNum = frameNum + 1
            end
        end
        index = index + 1
    end

    frame.auraRows = 0
    frame.largestAura = 0
    local mirrorAurasVertically = frame.buffsOnTop or false
    local maxRowWidth = db.AuraRow
    frame.spellbarAnchor = nil
    local xOffset = db.Roug and 5 or 3

    if isEnemy then
        TargetBuffSize(frame, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, xOffset, mirrorAurasVertically)
        TargetBuffSize(frame, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, xOffset, mirrorAurasVertically)
    else
        TargetBuffSize(frame, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, xOffset, mirrorAurasVertically)
        TargetBuffSize(frame, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, xOffset, mirrorAurasVertically)
    end

    if frame.spellbar then
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
            if RougeUI.db.AsuriFrame and not RougeUI.db.Roug then
                xPosOffset = 7
            elseif RougeUI.db.AsuriFrame and RougeUI.db.Roug then
                xPosOffset = 8
                AURA_OFFSET_Y = 2
            elseif RougeUI.db.Roug then
                xPosOffset = 6
                AURA_OFFSET_Y = 2
            end

            RougeUI.RougeUIF:HookAuras()
        end
    end
end)