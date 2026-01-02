local addonName, RougeUI = ...
local UnitIsUnit, UnitIsOwnerOrControllerOfUnit, UnitIsEnemy = _G.UnitIsUnit, _G.UnitIsOwnerOrControllerOfUnit, _G.UnitIsEnemy
local UnitBuff, UnitDebuff = _G.UnitBuff, _G.UnitDebuff
local UnitClass, UnitIsFriend = _G.UnitClass, _G.UnitIsFriend
local mabs, mfloor = math.abs, math.floor
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local AURA_OFFSET_Y = 1
local fontName, skinEnabled
local xPosOffset = 21
local dbfLoaded

local defaultList = {
    [16188] = true, -- Nature's Swiftness
    [12043] = true, -- Presence of Mind
    [12042] = true, -- Arcane Power
    [12472] = true, -- Icy Veins
    [31884] = true, -- Avenging Wrath
    [592] = true, -- Power Word: Shield
    [27273] = true, -- Sacrifice
    [27134] = true, -- Ice Barrier
    [22812] = true, -- Barkskin
    [1044] = true, -- Blessing of Freedom
    [29166] = true, -- Innervate
    [2825] = true, -- Bloodlust
    [32182] = true, -- Heroism
    [14751] = true, -- Inner Focus
    [10060] = true, -- Power Infusion
    [33206] = true, -- Pain Supression
    [27009] = true, -- Nature's Grasp
    [3045] = true, -- Rapid Fire
    [2651] = true, -- Elune's Grace
    [6346] = true, -- Fear Ward
    [20729] = true, -- Blessing of Sacrifice
    [10278] = true, -- Blessing of Protection
    [30458] = true, -- Nigh Invulnerability Belt
    [18708] = true, -- Fel Domination
    [45438] = true, -- Ice Block
    [1020] = true -- Divine Shield
}

local Whitelist = { ... }
for id in pairs(defaultList) do
    local name = GetSpellInfo(id)
    if name then
        Whitelist[name] = true
    end
end

local function GetFramePosition(frame)
    if not frame then
        return 0, 0
    end
    return frame:GetLeft() or 0, frame:GetBottom() or 0
end

local function UpdateAuraPositions(frame, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX, mirrorAurasVertically)
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

local function safeSetPoint(frame, point, relativeTo, relativePoint, x, y)
    if not frame or not relativeTo then
        return
    end
    local current = relativeTo
    while current do
        if current == frame then
            frame:ClearAllPoints()
            frame:SetPoint(point, relativeTo:GetParent(), relativePoint, x, y)
            return
        end
        local _, parent = current:GetPoint()
        current = parent
    end
    frame:ClearAllPoints()
    frame:SetPoint(point, relativeTo, relativePoint, x, y)
end

local function New_TargetFrame_UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local point, relativePoint;
    local startY, auraOffsetY;
    if ( mirrorVertically ) then
        point = "BOTTOM";
        relativePoint = "TOP";
        startY = -19;
        if ( self.threatNumericIndicator:IsShown() ) then
            startY = startY + self.threatNumericIndicator:GetHeight();
        end
        offsetY = - offsetY;
        auraOffsetY = -AURA_OFFSET_Y;
    else
        point = "TOP";
        relativePoint="BOTTOM";
        startY = 28;
        auraOffsetY = AURA_OFFSET_Y;
    end

    local buff = _G[buffName..index];
    if ( index == 1 ) then
        if ( UnitIsFriend("player", self.unit) or numDebuffs == 0 ) then
            -- unit is friendly or there are no debuffs...buffs start on top
            buff:SetPoint(point.."LEFT", self, relativePoint.."LEFT", xPosOffset, startY);
        else
            safeSetPoint(buff, point.."LEFT", self.debuffs, relativePoint.."LEFT", 0, -offsetY)
        end
        self.buffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0);
        self.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
        self.spellbarAnchor = buff;
    elseif ( anchorIndex ~= (index-1) ) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint(point.."LEFT", _G[buffName..anchorIndex], relativePoint.."LEFT", 0, -offsetY);
        self.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
        self.spellbarAnchor = buff;
    else
        -- anchor index is the previous index
        buff:SetPoint(point.."LEFT", _G[buffName..anchorIndex], point.."RIGHT", offsetX, 0);
    end

    -- Resize
    buff:SetWidth(size);
    buff:SetHeight(size);
end

local function New_TargetFrame_UpdateDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local buff = _G[debuffName..index];
    local isFriend = UnitIsFriend("player", self.unit);

    --For mirroring vertically
    local point, relativePoint;
    local startY, auraOffsetY;
    if ( mirrorVertically ) then
        point = "BOTTOM";
        relativePoint = "TOP";
        startY = -19;
        if ( self.threatNumericIndicator:IsShown() ) then
            startY = startY + self.threatNumericIndicator:GetHeight();
        end
        offsetY = - offsetY;
        auraOffsetY = -AURA_OFFSET_Y;
    else
        point = "TOP";
        relativePoint="BOTTOM";
        startY = 28;
        auraOffsetY = AURA_OFFSET_Y;
    end

    if ( index == 1 ) then
        if ( isFriend and numBuffs > 0 ) then
            -- unit is friendly and there are buffs...debuffs start on bottom
            buff:SetPoint(point.."LEFT", self.buffs, relativePoint.."LEFT", 0, -offsetY);
        else
            -- unit is not friendly or there are no buffs...debuffs start on top
            buff:SetPoint(point.."LEFT", self, relativePoint.."LEFT", xPosOffset, startY);
        end
        self.debuffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0);
        self.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
        if ( ( isFriend ) or ( not isFriend and numBuffs == 0) ) then
            self.spellbarAnchor = buff;
        end
    elseif ( anchorIndex ~= (index-1) ) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint(point.."LEFT", _G[debuffName..anchorIndex], relativePoint.."LEFT", 0, -offsetY);
        self.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
        if ( ( isFriend ) or ( not isFriend and numBuffs == 0) ) then
            self.spellbarAnchor = buff;
        end
    else
        -- anchor index is the previous index
        buff:SetPoint(point.."LEFT", _G[debuffName..(index-1)], point.."RIGHT", offsetX, 0);
    end

    -- Resize
    buff:SetWidth(size);
    buff:SetHeight(size);
    local debuffFrame =_G[debuffName..index.."Border"];
    debuffFrame:SetWidth(size+2);
    debuffFrame:SetHeight(size+2);
end

local largeBuffList = {}
local largeDebuffList = {}
local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true,
}

local function ShouldAuraBeLarge(caster)
    if (not GetCVarBool("showDynamicBuffSize")) then
        return true;
    end

    if not caster then
        return false;
    end

    for token, value in pairs(PLAYER_UNITS) do
        if UnitIsUnit(caster, token) or UnitIsOwnerOrControllerOfUnit(token, caster) then
            return value;
        end
    end
end

local function SkinAuraFrame(frame, frameName)
    if not frame or frame.skin or not skinEnabled then return end

    RougeUI.addBorder(frame)
    local icon = _G[frameName .. "Icon"]
        
    if RougeUI.db.modtheme then
        icon:SetTexCoord(.03, .97, .03, .97)
        icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
        icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
        frame.border:SetAllPoints(frame)
    else
        icon:SetTexCoord(.03, .97, .03, .97)
    end
        
    frame.skin = true
end

local function UpdateAuras(self)
    local selfName = self:GetName()

    if dbfLoaded then
        for i = 1, MAX_TARGET_BUFFS do
            local frameName = selfName .. "Buff" .. i
            local frame = _G[frameName]
            if frame then
                SkinAuraFrame(frame, frameName)
            end
        end
        for i = 1, MAX_TARGET_DEBUFFS do
            local frameName = selfName .. "Debuff" .. i
            local frame = _G[frameName]
            if frame then
                SkinAuraFrame(frame, frameName)
            end
        end
        return 
    end

    local db = RougeUI.db
    local frame, frameName
    local frameIcon, frameCount, frameCooldown
    local playerIsTarget = UnitIsUnit("player", self.unit)
    local canAssist = UnitCanAssist("player", self.unit)
    local _, _, class = UnitClass("player")
    local fontName

    local numBuffs = 0
    local buffIndex = 1

    AuraUtil.ForEachAura(self.unit, AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful), MAX_TARGET_BUFFS, function(...)
        local buffName, icon, count, debuffType, duration, expirationTime, caster, canStealOrPurge, _, spellId, _, _, casterIsPlayer, nameplateShowAll = ...
        if (buffName) then
            frameName = selfName .. "Buff" .. (buffIndex)
            frame = _G[frameName]
            if (not frame) then
                if (not icon) then
                    return false
                else
                    frame = CreateFrame("Button", frameName, self, "TargetBuffFrameTemplate")
                    frame.unit = self.unit
                end
            end
            
            if (icon and (not self.maxBuffs or buffIndex <= self.maxBuffs)) then
                SkinAuraFrame(frame, frameName)

                local showHighlight = false
                local r, g, b = 1, 1, 1
                local modifier = 1.2
                if db.Roug or db.Modern then
                    r, g, b = 1, 1, 0.75
                    modifier = 2.2
                end

                if db.HighlightDispellable then 
                    if not canAssist then
                        if Whitelist[buffName] and canStealOrPurge then
                            showHighlight = true
                        end
                    end
                end

                if db.HighlightDispellable and not canAssist and debuffType == "Magic" and (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
                    showHighlight = true
                elseif not canAssist and canStealOrPurge and not db.HighlightDispellable then
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

                frameCount = _G[frameName .. "Count"]
                if frameCount then
                    if (count > 1 and self.showAuraCount) then
                        frameCount:SetText(count)
                        frameCount:Show()
                    else
                        frameCount:Hide()
                    end
                    if not fontName then
                        fontName = frameCount:GetFont()
                    end
                    frameCount:SetFont(fontName, buffSize / 1.75, "OUTLINE, THICKOUTLINE, MONOCHROME")
                end

                buffIndex = buffIndex + 1
                numBuffs = numBuffs + 1
                largeBuffList[numBuffs] = ShouldAuraBeLarge(caster)
            end
        else
            return false
        end
        return numBuffs >= MAX_TARGET_BUFFS
    end)

    for i = buffIndex, MAX_TARGET_BUFFS do
        local buffFrame = _G[selfName .. "Buff" .. i]
        if (buffFrame) then
            buffFrame:Hide()
        else
            break
        end
    end

    local numDebuffs = 0
    local debuffIndex = 1
    local maxDebuffs = self.maxDebuffs or MAX_TARGET_DEBUFFS

    AuraUtil.ForEachAura(self.unit, AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.IncludeNameplateOnly), maxDebuffs, function(...)
        local debuffName, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _, _, casterIsPlayer, nameplateShowAll = ...
        if (debuffName) then
            if (self:ShouldShowDebuffs(self.unit, caster, nameplateShowAll, casterIsPlayer)) then
                frameName = selfName .. "Debuff" .. debuffIndex
                frame = _G[frameName]
                
                if (icon) then
                    SkinAuraFrame(frame, frameName)

                    local largeSize = ShouldAuraBeLarge(caster)

                    frameCount = _G[frameName .. "Count"]
                    if frameCount then
                        if (count > 1 and self.showAuraCount) then
                            frameCount:SetText(count)
                            frameCount:Show()
                        else
                            frameCount:Hide()
                        end
                        if not fontName then
                            fontName = frameCount:GetFont()
                        end
                        local buffSize = largeSize and db.SelfSize or db.OtherBuffSize
                        frameCount:SetFont(fontName, buffSize / 1.75, "OUTLINE, THICKOUTLINE, MONOCHROME")
                    end

                    debuffIndex = debuffIndex + 1
                    numDebuffs = numDebuffs + 1
                    largeDebuffList[numDebuffs] = ShouldAuraBeLarge(caster)
                end
            end
        else
            return false
        end
        return numDebuffs >= maxDebuffs
    end)

    for i = debuffIndex, MAX_TARGET_DEBUFFS do
        local debuffFrame = _G[selfName .. "Debuff" .. i]
        if (debuffFrame) then
            debuffFrame:Hide()
        else
            break
        end
    end

    self.auraRows = 0
    self.largestAura = 0

    local mirrorAurasVertically = false
    if (self.buffsOnTop) then
        mirrorAurasVertically = true
    end

    self.spellbarAnchor = nil
    
    local maxRowWidth = db.AuraRow
    local xOffset = db.Roug and 5 or 3

    if UnitIsEnemy("player", self.unit) then
        UpdateAuraPositions(self, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, xOffset, mirrorAurasVertically)
        UpdateAuraPositions(self, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, xOffset, mirrorAurasVertically)
    else
        UpdateAuraPositions(self, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, xOffset, mirrorAurasVertically)
        UpdateAuraPositions(self, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, xOffset, mirrorAurasVertically)
    end

    if self.spellbar ~= nil then
        self.spellbar:AdjustPosition()
    end
end

function RougeUI.RougeUIF:SetCustomBuffSize()
    local frames = {
        TargetFrame,
        FocusFrame
    }

    for _, frame in pairs(frames) do
        frame:UpdateAuras()
    end
end

function RougeUI.RougeUIF:HookAuras()
    if IsAddOnLoaded("DeBuffFilter") then
        dbfLoaded = true
    end
    
    hooksecurefunc(TargetFrame, "UpdateAuras", UpdateAuras)
    if FocusFrame then 
        hooksecurefunc(FocusFrame, "UpdateAuras", UpdateAuras)
    end
end

local FF = CreateFrame("Frame")
FF:RegisterEvent("PLAYER_LOGIN")
FF:SetScript("OnEvent", function(self, fireEvent)
    if fireEvent == "PLAYER_LOGIN" then
        if RougeUI.db.BuffSizer or RougeUI.db.HighlightDispellable then
            if RougeUI.db.AsuriFrame and not RougeUI.db.Roug then
                xPosOffset = 23
            elseif RougeUI.db.AsuriFrame and RougeUI.db.Roug then
                xPosOffset = 25 -- xx
                AURA_OFFSET_Y = 2
            elseif RougeUI.db.Roug then
                xPosOffset = 22
                AURA_OFFSET_Y = 2
            end

            skinEnabled = RougeUI.db.Lorti or RougeUI.db.Roug or RougeUI.db.Modern or RougeUI.db.modtheme

            RougeUI.RougeUIF:HookAuras()
        end
    end
end)