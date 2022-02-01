local DEFAULT_BUFF_SIZE = 17
local AURA_ROW_WIDTH = 122;
local NUM_TOT_AURA_ROWS = 2;
local AURA_OFFSET = 3;

function SetCustomBuffSize(value)
    local frames = {
        TargetFrame,
        FocusFrame
    }

    for _, frame in pairs(frames) do
	local LARGE_AURA_SIZE = RougeUI.SelfSize 
	local SMALL_AURA_SIZE = RougeUI.OtherBuffSize

        local buffSize = DEFAULT_BUFF_SIZE
        local frameName
        local icon
        local caster
        local _
        local selfName = frame:GetName()

        for i = 1, MAX_TARGET_BUFFS do
            _, icon, _, _, _, _, caster = UnitBuff(frame.unit, i)
            frameName = selfName .. 'Buff' .. i

            if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
                if (value) then
                    if (caster == 'player') then
                        buffSize = LARGE_AURA_SIZE
                    else
                        buffSize = SMALL_AURA_SIZE
                    end
                end

                _G[frameName]:SetHeight(buffSize)
                _G[frameName]:SetWidth(buffSize)
            end
        end
    end
end

local function TargetBuffSize(frame, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX, mirrorAurasVertically)
	local LARGE_AURA_SIZE = RougeUI.SelfSize
	local SMALL_AURA_SIZE = RougeUI.OtherBuffSize
        local size
        local offsetY = AURA_OFFSET
        local offsetX = AURA_OFFSET
        local rowWidth = 0
        local firstBuffOnRow = 1

        for i = 1, numAuras do
            if (largeAuraList[i]) then
                size = LARGE_AURA_SIZE
                offsetY = AURA_OFFSET
                offsetX = AURA_OFFSET
            else
                size = SMALL_AURA_SIZE
            end

            if (i == 1) then
                rowWidth = size
--		frame.auraRows = frame.auraRows + 1;
            else
                rowWidth = rowWidth + size + offsetX
            end

            if (rowWidth > maxRowWidth) then
                updateFunc(frame, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically)
                rowWidth = size
--		frame.auraRows = frame.auraRows + 1;
                firstBuffOnRow = i
                offsetY = AURA_OFFSET
		if ( frame.auraRows > NUM_TOT_AURA_ROWS ) then
			maxRowWidth = AURA_ROW_WIDTH;
		end
            else
                updateFunc(frame, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically)
            end
        end
end

function Custom_TargetBuffSize()
    hooksecurefunc("TargetFrame_UpdateAuraPositions", TargetBuffSize);
end

local Whitelist = {
	[16188] = true, -- Nature's Swiftness
	[17116] = true, -- Nature's Swiftness
	[12043] = true, -- Presence of Mind
	[12042] = true, -- Arcane Power
	[12472] = true, -- Icy Veins
	[31884] = true, -- Avenging Wrath
	[25218] = true, -- Power Word: Shield
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
	[27148] = true, -- Blessing of Sacrifice
	[10278] = true, -- Blessing of Protection
	[30458] = true, -- Nigh Invulnerability Belt
	[18708] = true, -- Fel Domination
	[45438] = true, -- Ice Block
	[1020] = true -- Divine Shield
};


local function Target_Update(frame)
    local buffFrame, frameStealable, icon, debuffType, isStealable, spellId, _
    local selfName = frame:GetName()
    local isEnemy = UnitIsEnemy(PlayerFrame.unit, frame.unit)

    for i = 1, MAX_TARGET_BUFFS do
        _, icon, _, debuffType, _, _, _, isStealable, _, spellId = UnitBuff(frame.unit, i)
	if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
		local frameName = selfName .. 'Buff' .. i
		buffFrame = _G[frameName]
		frameStealable = _G[frameName .. 'Stealable']
		if (isEnemy and debuffType == "Magic" and isStealable and Whitelist[spellId]) then
			local buffSize
			buffSize = RougeUI.OtherBuffSize
                	buffFrame:SetHeight(buffSize)
			buffFrame:SetWidth(buffSize)
                	frameStealable:Show()
			frameStealable:SetHeight(buffSize * 1.4)
                	frameStealable:SetWidth(buffSize * 1.4)
		else
			frameStealable:Hide()
		end
	end
    end
end

local function AdjustSpellBar(self)
	local parentFrame = self:GetParent()
	if ( parentFrame.haveToT ) then
		if ( parentFrame.buffsOnTop or parentFrame.auraRows <= 1 ) then
			parentFrame.spellbar:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -21 )
		else
			parentFrame.spellbar:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
		end
	elseif ( parentFrame.haveElite ) then
		if ( parentFrame.buffsOnTop or parentFrame.auraRows <= 1 ) then
			parentFrame.spellbar:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -5 )
		else
			parentFrame.spellbar:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
		end
	else
		if ( (not parentFrame.buffsOnTop) and parentFrame.auraRows > 0 ) then
			parentFrame.spellbar:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
		else
			parentFrame.spellbar:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, 7 )
		end
	end
end
hooksecurefunc("Target_Spellbar_AdjustPosition", AdjustSpellBar)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" and RougeUI.HighlightDispellable == true then
		hooksecurefunc("TargetFrame_UpdateAuras", Target_Update);
	end
	self:UnregisterEvent("PLAYER_LOGIN")
	self:SetScript("OnEvent", nil)
end);
