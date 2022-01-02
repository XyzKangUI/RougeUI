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
--                offsetX = AURA_OFFSET
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

-- Track Max rank & important spells. This way can easily filter thrash buffs without checking tooltip.
local Whitelist = {
	[16188] = true, -- Nature's Swiftness
	[17116] = true, -- Nature's Swiftness
	[12043] = true, -- Presence of Mind
	[12042] = true, -- Arcane Power
	[12472] = true, -- Icy Veins
	[31884] = true, -- Avenging Wrath
	[25218] = true, -- Power Word: Shield
	[27134] = true, -- Ice Barrier
	[6346] = true, -- Fear Ward
	[22812] = true, -- Barkskin
	[30458] = true, -- Nigh Invulnerability Belt
	[18708] = true, -- Fel Domination
	[20729] = true, -- Blessing of Sacrifice
	[27148] = true, -- BoS
	[1044] = true, -- Blessing of Freedom
	[10278] = true, -- Blessing of Protection
	[29166] = true, -- Innervate
	[2825] = true, -- Bloodlust
	[32182] = true, -- Heroism
	[25431] = true, -- Inner Fire
	[14751] = true, -- Inner Focus
	[26990] = true, -- Mark of the Wild
	[26991] = true, -- Gift of the Wild
	[25392] = true, -- Prayer of Fortitude
	[25389] = true, -- Power Word: Fortitude
	[25433] = true, -- Shadow Protection
	[39374] = true, -- Prayer of Shadow Protection
	[25312] = true, -- Divine Spirit
	[32999] = true, -- Prayer of Spirit
	[10060] = true, -- Power Infusion
	[33206] = true, -- Pain Supression
	[27009] = true, -- Nature's Grasp
	[3045] = true, -- Rapid Fire
	[2651] = true, -- Elune's Grace
	[2893] = true, -- Abolish Poison
	[26982] = true -- Rejuvenation
};

local function Target_Update(frame)
    local buffFrame, frameStealable, icon, debuffType, isStealable, _
    local selfName = frame:GetName()
    local isEnemy = UnitIsEnemy(PlayerFrame.unit, frame.unit)

    for i = 1, MAX_TARGET_BUFFS do
        _, icon, _, debuffType, _, _, _, isStealable, _, spellId = UnitBuff(frame.unit, i)
        if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
            local frameName = selfName .. 'Buff' .. i
            buffFrame = _G[frameName]
            frameStealable = _G[frameName .. 'Stealable']
            if (isEnemy and debuffType == 'Magic' and Whitelist[spellId]) then
		local buffSize
		buffSize = RougeUI.OtherBuffSize
                buffFrame:SetHeight(buffSize)
                buffFrame:SetWidth(buffSize)
                frameStealable:SetHeight(buffSize * 1.4)
                frameStealable:SetWidth(buffSize * 1.4)
                frameStealable:Show()
            end
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event)
	if (RougeUI.HighlightDispellable == true) then
		hooksecurefunc("TargetFrame_UpdateAuras", Target_Update);
	end
	f:UnregisterAllEvents()
	f:SetScript("OnEvent", nil)
end);
