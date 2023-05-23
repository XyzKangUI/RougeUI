local _, RougeUI = ...
local _G = getfenv(0)
local AURA_OFFSET_Y = 3
local AURA_START_X = 5
local AURA_START_Y = 32
local OFFSET_X = 3
local GetSpellInfo, hooksecurefunc, UnitIsFriend = _G.GetSpellInfo, _G.hooksecurefunc, _G.UnitIsFriend
local UnitIsUnit, UnitIsOwnerOrControllerOfUnit, UnitIsEnemy, UnitClass = _G.UnitIsUnit, _G.UnitIsOwnerOrControllerOfUnit, _G.UnitIsEnemy, _G.UnitClass
local UnitBuff, UnitDebuff = _G.UnitBuff, _G.UnitDebuff
local pairs = _G.pairs
local MAX_TARGET_DEBUFFS = 16;
local MAX_TARGET_BUFFS = 32;
local mceil = math.ceil

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

};

local function ToTegrity(frame)
    if not (frame == TargetFrameToT or frame == FocusFrameToT) then
        return
    end

    local _, _, a, b, c = frame:GetPoint()

    if (a == "BOTTOMRIGHT") and (mceil(b) == -35) and (mceil(c) == -10) then
        return true
    else
        return false
    end
end

local function maxRows(self, width, mirror)
    local haveTargetofTarget

    if self.totFrame ~= nil then
        haveTargetofTarget = self.totFrame:IsShown();
    end

    if (haveTargetofTarget and self.auraRows <= 2) and not mirror and ToTegrity(self.totFrame) then
        return self.TOT_AURA_ROW_WIDTH
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

    maxRowWidth = AURA_ROW_WIDTH;

    for i = 1, numAuras do
        if (largeAuraList[i]) then
            size = LARGE_AURA_SIZE
            offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y
        else
            size = SMALL_AURA_SIZE
        end

        if (i == 1) then
            rowWidth = size
            frame.auraRows = frame.auraRows + 1;
        else
            rowWidth = rowWidth + size + offsetX
        end

        if (rowWidth > maxRows(frame, maxRowWidth, mirrorAurasVertically)) then
            updateFunc(frame, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically)
            rowWidth = size
            frame.auraRows = frame.auraRows + 1;
            firstBuffOnRow = i
            offsetY = AURA_OFFSET_Y
        else
            updateFunc(frame, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically)
        end
    end
end

local function New_Target_Spellbar_AdjustPosition(self)
    local parentFrame = self:GetParent();
    if (self.boss) then
        self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, 10);
    elseif (parentFrame.haveToT) then
        if (parentFrame.buffsOnTop or parentFrame.auraRows <= 1) then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -25);
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15);
        end
    elseif (parentFrame.haveElite) then
        if (parentFrame.buffsOnTop or parentFrame.auraRows <= 1) then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -5);
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15);
        end
    else
        if ((not parentFrame.buffsOnTop) and parentFrame.auraRows > 0) then
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15);
        else
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, 7);
        end
    end
end

local function New_TargetFrame_UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    --For mirroring vertically
    local point, relativePoint;
    local startY, auraOffsetY;
    if (mirrorVertically) then
        point = "BOTTOM";
        relativePoint = "TOP";
        startY = -9;
        offsetY = -offsetY;
        auraOffsetY = -AURA_OFFSET_Y;
    else
        point = "TOP";
        relativePoint = "BOTTOM";
        startY = AURA_START_Y;
        auraOffsetY = AURA_OFFSET_Y;
    end

    local buff = _G[buffName .. index];
    if (index == 1) then
        if (UnitIsFriend("player", self.unit) or numDebuffs == 0) then
            -- unit is friendly or there are no debuffs...buffs start on top
            buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", AURA_START_X, startY);
        else
            -- unit is not friendly and we have debuffs...buffs start on bottom
            buff:SetPoint(point .. "LEFT", self.debuffs, relativePoint .. "LEFT", 0, -offsetY);
        end
        self.buffs:SetPoint(point .. "LEFT", buff, point .. "LEFT", 0, 0);
        self.buffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY);
        self.spellbarAnchor = buff;
    elseif (anchorIndex ~= (index - 1)) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint(point .. "LEFT", _G[buffName .. anchorIndex], relativePoint .. "LEFT", 0, -offsetY);
        self.buffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY);
        self.spellbarAnchor = buff;
    else
        -- anchor index is the previous index
        buff:SetPoint(point .. "LEFT", _G[buffName .. anchorIndex], point .. "RIGHT", offsetX, 0);
    end

    -- Resize
    buff:SetWidth(size);
    buff:SetHeight(size);
end

local function New_TargetFrame_UpdateDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local buff = _G[debuffName .. index];
    local isFriend = UnitIsFriend("player", self.unit);

    --For mirroring vertically
    local point, relativePoint;
    local startY, auraOffsetY;
    if (mirrorVertically) then
        point = "BOTTOM";
        relativePoint = "TOP";
        startY = -15;
        offsetY = -offsetY;
        auraOffsetY = -AURA_OFFSET_Y;
    else
        point = "TOP";
        relativePoint = "BOTTOM";
        startY = AURA_START_Y;
        auraOffsetY = AURA_OFFSET_Y;
    end

    if (index == 1) then
        if (isFriend and numBuffs > 0) then
            -- unit is friendly and there are buffs...debuffs start on bottom
            buff:SetPoint(point .. "LEFT", self.buffs, relativePoint .. "LEFT", 0, -offsetY);
        else
            -- unit is not friendly or there are no buffs...debuffs start on top
            buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", AURA_START_X, startY);
        end
        self.debuffs:SetPoint(point .. "LEFT", buff, point .. "LEFT", 0, 0);
        self.debuffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY);
        if ((isFriend) or (not isFriend and numBuffs == 0)) then
            self.spellbarAnchor = buff;
        end
    elseif (anchorIndex ~= (index - 1)) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint(point .. "LEFT", _G[debuffName .. anchorIndex], relativePoint .. "LEFT", 0, -offsetY);
        self.debuffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY);
        if ((isFriend) or (not isFriend and numBuffs == 0)) then
            self.spellbarAnchor = buff;
        end
    else
        -- anchor index is the previous index
        buff:SetPoint(point .. "LEFT", _G[debuffName .. (index - 1)], point .. "RIGHT", offsetX, 0);
    end

    -- Resize
    buff:SetWidth(size);
    buff:SetHeight(size);
    local debuffFrame = _G[debuffName .. index .. "Border"];
    debuffFrame:SetWidth(size + 2);
    debuffFrame:SetHeight(size + 2);
end

local largeBuffList = {};
local largeDebuffList = {};
local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true,
};

local function ShouldAuraBeLarge(caster)
    if not caster then
        return false;
    end

    for token, value in pairs(PLAYER_UNITS) do
        if UnitIsUnit(caster, token) or UnitIsOwnerOrControllerOfUnit(token, caster) then
            return value;
        end
    end
end

local function Target_Update(frame)
    if not (frame == TargetFrame or frame == FocusFrame) then
        return
    end

    local buffFrame, frameStealable, frameName
    local frameIcon, frameCount, frameCooldown
    local numBuffs = 0;
    local selfName = frame:GetName()
    local isEnemy = UnitIsEnemy(PlayerFrame.unit, frame.unit)
    local _, _, class = UnitClass("player")

    for i = 1, MAX_TARGET_BUFFS do
        local name, icon, count, _, duration, expirationTime, caster, isStealable, _, spellId = UnitBuff(frame.unit, i, nil);
        if (name) then
            frameName = selfName .. "Buff" .. i
            buffFrame = _G[frameName]
            frameStealable = _G[frameName .. "Stealable"]

            if (not buffFrame) then
                if (not icon) then
                    break ;
                else
                    buffFrame = CreateFrame("Button", frameName, frame, "TargetBuffFrameTemplate");
                    buffFrame.unit = frame.unit;
                end
            end
            if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
                buffFrame:SetID(i);

                -- set the icon
                frameIcon = _G[frameName .. "Icon"];
                frameIcon:SetTexture(icon);

                -- set the count
                frameCount = _G[frameName .. "Count"];
                if (count > 1 and frame.showAuraCount) then
                    frameCount:SetText(count);
                    frameCount:Show();
                else
                    frameCount:Hide();
                end

                -- Handle cooldowns
                frameCooldown = _G[frameName .. "Cooldown"];
                CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

                if RougeUI.db.HighlightDispellable then
                    if isEnemy and (Whitelist[name] and isStealable) or ((class == 4 or class == 3) and (isEnemy and Enraged[spellId])) or spellId == 31821 or spellId == 49039 or spellId == 53659 then
                        local buffSize = RougeUI.db.OtherBuffSize
                        buffFrame:SetHeight(buffSize)
                        buffFrame:SetWidth(buffSize)
                        frameStealable:Show()
                        frameStealable:SetHeight(buffSize * 1.4)
                        frameStealable:SetWidth(buffSize * 1.4)
                        if Whitelist[name] and isStealable then
                            frameStealable:SetVertexColor(1, 1, 1) -- White
                        elseif (class == 4 or class == 3) and (isEnemy and Enraged[spellId]) then
                            frameStealable:SetVertexColor(1, 0, 0) -- Red
                        elseif spellId == 31821 then
                            -- Highlight Aura mastery
                            frameStealable:SetVertexColor(0, 0, 1) -- Blue
                        elseif spellId == 49039 and (class == 5 or class == 2) then
                            -- Highlight Lichborne for shackle/turn evil
                            frameStealable:SetVertexColor(1, 0, 127 / 255) -- Pink
                        elseif spellId == 53659 then
                            frameStealable:SetVertexColor(52 / 255, 235 / 255, 146 / 255) -- Green
                        else
                            frameStealable:SetVertexColor(1, 1, 1) -- Normal (white)
                        end
                    else
                        frameStealable:SetVertexColor(1, 1, 1)
                        frameStealable:Hide()
                    end
                else
                    local buffSize = RougeUI.db.OtherBuffSize
                    buffFrame:SetHeight(buffSize)
                    buffFrame:SetWidth(buffSize)
                end

                -- set the buff to be big if the buff is cast by the player or his pet
                numBuffs = numBuffs + 1;
                largeBuffList[numBuffs] = ShouldAuraBeLarge(caster);

                buffFrame:ClearAllPoints();
                buffFrame:Show();
            else
                buffFrame:Hide();
            end
        else
            break ;
        end
    end
    for i = numBuffs + 1, MAX_TARGET_BUFFS do
        local frame = _G[selfName .. "Buff" .. i];
        if (frame) then
            frame:Hide();
        else
            break ;
        end
    end

    local color;
    local frameBorder;
    local numDebuffs = 0;

    local frameNum = 1;
    local index = 1;

    local maxDebuffs = frame.maxDebuffs or MAX_TARGET_DEBUFFS;
    while (frameNum <= maxDebuffs and index <= maxDebuffs) do
        local debuffName, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _, _, casterIsPlayer, nameplateShowAll = UnitDebuff(frame.unit, index, "INCLUDE_NAME_PLATE_ONLY");
        if (debuffName) then
            if (TargetFrame_ShouldShowDebuffs(frame.unit, caster, nameplateShowAll, casterIsPlayer)) then
                frameName = selfName .. "Debuff" .. frameNum;
                buffFrame = _G[frameName];
                if (icon) then
                    if (not buffFrame) then
                        buffFrame = CreateFrame("Button", buffFrame, frame, "TargetDebuffFrameTemplate");
                        buffFrame.unit = frame.unit;
                    end
                    buffFrame:SetID(index);

                    -- set the icon
                    frameIcon = _G[frameName .. "Icon"];
                    frameIcon:SetTexture(icon);

                    -- set the count
                    frameCount = _G[frameName .. "Count"];
                    if (count > 1 and frame.showAuraCount) then
                        frameCount:SetText(count);
                        frameCount:Show();
                    else
                        frameCount:Hide();
                    end

                    -- Handle cooldowns
                    frameCooldown = _G[frameName .. "Cooldown"];
                    CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

                    -- set debuff type color
                    if (debuffType) then
                        color = DebuffTypeColor[debuffType];
                    else
                        color = DebuffTypeColor["none"];
                    end
                    frameBorder = _G[frameName .. "Border"];
                    frameBorder:SetVertexColor(color.r, color.g, color.b);

                    -- set the debuff to be big if the buff is cast by the player or his pet
                    numDebuffs = numDebuffs + 1;
                    largeDebuffList[numDebuffs] = ShouldAuraBeLarge(caster);

                    buffFrame:ClearAllPoints();
                    buffFrame:Show();

                    frameNum = frameNum + 1;
                end
            end
        else
            break ;
        end
        index = index + 1;
    end

    for i = frameNum, MAX_TARGET_DEBUFFS do
        local frameName = _G[selfName .. "Debuff" .. i];
        if (frameName) then
            frameName:Hide();
        else
            break ;
        end
    end

    frame.auraRows = 0;

    local mirrorAurasVertically = false;
    if (frame.buffsOnTop) then
        mirrorAurasVertically = true;
    end

    frame.spellbarAnchor = nil;
    local maxRowWidth = RougeUI.db.AuraRow
    if (UnitIsFriend("player", frame.unit)) then
        -- update buff positions
        TargetBuffSize(frame, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, OFFSET_X, mirrorAurasVertically);
        -- update debuff positions
        TargetBuffSize(frame, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, OFFSET_X, mirrorAurasVertically);
    else
        -- update debuff positions
        TargetBuffSize(frame, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, New_TargetFrame_UpdateDebuffAnchor, maxRowWidth, OFFSET_X, mirrorAurasVertically);
        -- update buff positions
        TargetBuffSize(frame, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, New_TargetFrame_UpdateBuffAnchor, maxRowWidth, OFFSET_X, mirrorAurasVertically);
    end
    -- update the spell bar position
    if (frame.spellbar) then
        New_Target_Spellbar_AdjustPosition(frame.spellbar);
    end
end

function RougeUI.RougeUIF:SetCustomBuffSize()
    local frames = {
        TargetFrame,
        FocusFrame
    }

    for _, frame in pairs(frames) do
        TargetFrame_UpdateAuras(frame);
    end
end

function RougeUI.RougeUIF:HookAuras()
    hooksecurefunc("TargetFrame_UpdateAuraPositions", TargetBuffSize);
    hooksecurefunc("Target_Spellbar_AdjustPosition", New_Target_Spellbar_AdjustPosition)
    hooksecurefunc("TargetFrame_UpdateAuras", Target_Update);
end

local FF = CreateFrame("Frame")
FF:RegisterEvent("PLAYER_LOGIN")
FF:SetScript("OnEvent", function(self)
    if RougeUI.db.BuffSizer or RougeUI.db.HighlightDispellable then
        RougeUI.RougeUIF:HookAuras()
    end

    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)