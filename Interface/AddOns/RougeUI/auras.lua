local DEFAULT_BUFF_SIZE = 17
local AURA_ROW_WIDTH = 122;
local NUM_TOT_AURA_ROWS = 2;
local AURA_OFFSET = 3;

function RougeUIF:SetCustomBuffSize(value)
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
        local offsetY = AURA_OFFSET + 1
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
--		    frame.auraRows = frame.auraRows + 1;
            else
                rowWidth = rowWidth + size + offsetX
            end

            if (rowWidth > maxRowWidth) then
                updateFunc(frame, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically)
                rowWidth = size
--		    frame.auraRows = frame.auraRows + 1;
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

function RougeUIF:Custom_TargetBuffSize()
    hooksecurefunc("TargetFrame_UpdateAuraPositions", TargetBuffSize);
end

local Enraged = {
	[5229] = true,
	[1719] = true,
	[12880] = true,
	[14204] = true,
	[14202] = true,
	[14203] = true,
	[14201] = true,
	[18499] = true,
	[12292] = true,
	[2687] = true,
	[29131] = true,
	[48391] = true,
	[49016] = true,
	[50636] = true,
	[51662] = true,
	[54508] = true,
	[57514] = true,
	[57516] = true,
	[57518] = true,
	[57519] = true,
	[57520] = true,
	[57522] = true,
	[63147] = true,
	[66759] = true,
	[62071] = true,
	[51513] = true,
	[60177] = true,
	[57521] = true,
	[63848] = true,
	[52610] = true,
	[66759] = true,
}

local Whitelist = {
	[GetSpellInfo(16188)] = true, -- Nature's Swiftness
	[GetSpellInfo(17116)] = true, -- Nature's Swiftness
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
};

local function Target_Update(frame)
	local buffFrame, frameStealable, icon, debuffType, isStealable, spellId, _
	local selfName = frame:GetName()
	local isEnemy = UnitIsEnemy(PlayerFrame.unit, frame.unit)
	local _, _, class = UnitClass("player")

	for i = 1, MAX_TARGET_BUFFS do
		 name, icon, _, debuffType, _, _, _, isStealable, _, spellId = UnitBuff(frame.unit, i)
		if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
			local frameName = selfName .. "Buff" .. i
			buffFrame = _G[frameName]
			frameStealable = _G[frameName .. "Stealable"]

			if isEnemy and (Whitelist[name] and isStealable ) or ((class == 4 or class == 3) and (isEnemy and Enraged[spellId])) or spellId == 31821 or spellId == 49039 then
				local buffSize = RougeUI.OtherBuffSize
				buffFrame:SetHeight(buffSize)
				buffFrame:SetWidth(buffSize)
				frameStealable:Show()
				frameStealable:SetHeight(buffSize * 1.3)
				frameStealable:SetWidth(buffSize * 1.3)
				if Whitelist[name] and isStealable then
					frameStealable:SetVertexColor(1, 1, 1) -- White	
				elseif (class == 4 or class == 3) and (isEnemy and Enraged[spellId]) then
					frameStealable:SetVertexColor(1, 0, 0) -- Red
				elseif spellId == 31821 then -- Highlight Aura mastery
					frameStealable:SetVertexColor(1, 1, 0) -- Yellow
				elseif spellId == 49039 and (class == 5 or class == 2) then -- Highlight Lichborne for shackle/turn evil
					frameStealable:SetVertexColor(1, 0, 127/255) -- Pink
				else
					frameStealable:SetVertexColor(1, 1, 1) -- Normal (white)
				end
			else
				frameStealable:SetVertexColor(1, 1, 1)
				frameStealable:Hide()
			end
		end
    	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" and RougeUI.HighlightDispellable == true then
		hooksecurefunc("TargetFrame_UpdateAuras", Target_Update);
	end
	self:UnregisterEvent("PLAYER_LOGIN")
	self:SetScript("OnEvent", nil)
end);