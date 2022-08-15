local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")

local function SetCustomVars()
	SetCVar("namenameplateSelectedScale", 1.15)
	SetCVar("namenameplateGlobalScale", 1.1)
	SetCVar("ShowClassColorInFriendlyNameplate", 0)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("nameplateMaxDistance", 41)
	SetCVar("enableFloatingCombatText", 1)
end

local function log(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end
local currentLatency
RougeUI = RougeUI or { move = false }

SLASH_PVPUI1 = '/rougeadmin';
function SlashCmdList.PVPUI (msg, editBox)
	if msg == 'move' then
		if RougeUI.move == false then
			RougeUI.move = true
			log("Activated personal settings")
		else
			RougeUI.move = false
			log("Deactivated personal settings")
		end
	end
end

local function MoveFrames(self, event, ...)
	local _, class = UnitClass("player")
		if RougeUI.move == true then
			PlayerFrame:ClearAllPoints()
--			PlayerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 152.9, -103.09)
--			PlayerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 152.9, -129.48)
			TargetFrame:ClearAllPoints()
--			TargetFrame:SetPoint("TOP", UIParent, "TOP", -274.99, -124,42)
--			PlayerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 142.39, -124,42)
			TargetFrame:SetPoint("TOP", UIParent, "TOP", -299.22, -103.09)
			PlayerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 117.9, -103.09)
			FocusFrameSpellBar:SetScale(1.1)
--			PartyMemberFrame1:ClearAllPoints()
--			PartyMemberFrame1:SetPoint("TOPLEFT", CompactRaidFrameManager, "TOPRIGHT", 136, -73)
			TargetFrameToT:ClearAllPoints();
			TargetFrameToT:SetPoint("CENTER", TargetFrame, "Right", -50, -45);
			FocusFrameToT:ClearAllPoints();
			FocusFrameToT:SetPoint("CENTER", FocusFrame, "Right", -50, -45)
			FocusFrameTextureFramePVPIcon:SetAlpha(0)
			MiniMapBattlefieldBorder:Hide()
			BattlegroundShine:Hide()
			MinimapZoneText:Hide()
		end
end

local function MoveBuffs(buttonName, index)
		if RougeUI.move == true then
			BuffFrame:ClearAllPoints()
			BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -245, -113)
			BuffFrame:SetScale(1.15)
			TemporaryEnchantFrame:SetScale(1.15)
		end
end

local function SpellQueueFix()
	local _, _, latencyHome, latencyWorld = GetNetStats();
	local _, class = UnitClass("player")
	local value

	if (latencyHome or latencyWorld) == 0 then C_Timer.After(40, SpellQueueFix) return end

	if latencyHome >= latencyWorld then
		currentLatency = latencyHome
	elseif latencyWorld > latencyHome then
		currentLatency = latencyWorld
	end

	if class == "ROGUE" then
		value = 200 + currentLatency
		ConsoleExec("SpellQueueWindow "..value)
	elseif class ~= "ROGUE" then
		value = 250 + currentLatency
		ConsoleExec("SpellQueueWindow "..value)
	end
end

hooksecurefunc("UIParent_UpdateTopFramePositions", MoveBuffs)

f:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		MoveFrames()
		SetCustomVars()
		self:UnregisterEvent("PLAYER_LOGIN")
	elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
		SpellQueueFix()
	end
end)

-- Raidframe resizer
local n,w,h="CompactUnitFrameProfilesGeneralOptionsFrame" h,w=
_G[n.."HeightSlider"],
_G[n.."WidthSlider"] 
h:SetMinMaxValues(1,150) 
w:SetMinMaxValues(1,150)