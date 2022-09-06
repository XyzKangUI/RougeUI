local hooksecurefunc = hooksecurefunc
local pairs = pairs
local IsAddOnLoaded = IsAddOnLoaded
local GetNetStats = GetNetStats
local IsInInstance = IsInInstance
local UnitClass, UnitExists, UnitGUID, UnitCanAttack = UnitClass, UnitExists, UnitGUID, UnitCanAttack
local UnitIsPlayer, UnitPlayerControlled, UnitIsUnit, UnitIsEnemy = UnitIsPlayer, UnitPlayerControlled, UnitIsUnit, UnitIsEnemy
local UnitIsConnected, UnitSelectionColor, UnitIsTapDenied, UnitPlayerControlled = UnitIsConnected, UnitSelectionColor, UnitIsTapDenied, UnitPlayerControlled


local addonlist = {
	["Shadowed Unit Frames"] = true, 
	["PitBull Unit Frames 4.0"] = true, 
	["X-Perl UnitFrames"] = true, 
	["Z-Perl UnitFrames"] = true, 
	["EasyFrames"] = true,
	["ElvUI"] = true, 
	["Uber UI Classic"] = true, 
	["whoaThickFrames_BCC"] = true, 
	["whoaUnitFrames_BCC"] = true, 
	["AbyssUI"] = true, 
	["KkthnxUI"] = true,
	["TextureScript"] = true,
	["DarkModeUI"] = true,
	["SUI"] = true,
	["RiizUI"] = true
}

-- Hide MultiGroupFrame icons showing as Party(+BG) leader
local mg = PlayerPlayTime:GetParent().MultiGroupFrame
hooksecurefunc(mg, "Show", mg.Hide)

-- Remove gap in buff timers & color the format
local function TimeFormat(button, time)
	local duration = _G[button:GetName().."Duration"]
	local floor, fmod = math.floor, math.fmod
	local h, m, s, text

	if time <= 0 then
	    text = ""
        elseif time < 3600 and time > 60 then
			h = floor(time/3600)
			m = floor(mod(time, 3600)/60 + 1)
            s = fmod(time, 60)
            text = duration:SetFormattedText("|r%d|rm", m)
        elseif time < 60 then
            m = floor(time/60)
            s = fmod(time, 60)
            text = m == 0 and duration:SetFormattedText("|r%d|rs", s)
        else
            h = floor(time/3600 + 1)
            text = duration:SetFormattedText("|r%d|rh", h)
        end
        return text
end

-- Hide Raid frame titles

local function HideFrameTitles(groupIndex)
	local frame 

	if not groupIndex then
		frame = _G["CompactPartyFrameTitle"]
	else
		frame = _G["CompactRaidGroup"..groupIndex.."Title"]
	end

	if frame then
		frame:Hide()
	end
end

-- Class colored scoreboard
local function ColorScoreBoard()
	local inInstance, instanceType = IsInInstance()
	if ( instanceType ~= "pvp" ) then return end
	for i = 1, 22 do
		local ScoreBoard = _G["WorldStateScoreButton"..i]

        	if ScoreBoard and ScoreBoard.index then
            		local _, _, _, _, _, _, _, _, _, filename = GetBattlefieldScore(ScoreBoard.index)
            		local text = ScoreBoard.name.text:GetText()

            		if text and filename then
                		local color = GetClassColorObj(filename)
                		ScoreBoard.name.text:SetText(color:WrapTextInColorCode(text))
            		end
        	end
	end
end

-- Some PvPIcon tweaks for BG/Arena/CP Classes

local function PvPIcon()
	local inInstance, instanceType = IsInInstance()
	for i,v in pairs({
		PlayerPVPIcon,
		FocusFrameTextureFramePVPIcon,
		TargetFrameTextureFramePVPIcon
	}) do	
		if instanceType == "arena" then
			v:SetAlpha(0)
		else
			v:SetAlpha(0.45)
		end
	end
end

-- Fix crossfaction BG showing wrong PvP icon on PlayerFrame
local function FixPvPFrame(frame)
		if AuraUtil.FindAuraByName(GetSpellInfo(81748), "player") then
				PlayerPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-Alliance")
		elseif AuraUtil.FindAuraByName(GetSpellInfo(81744), "player") then
				PlayerPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-Horde")
		end
end
hooksecurefunc("PlayerFrame_UpdatePvPStatus", FixPvPFrame);

-- Hide indicators and fancy glows

local function HideGlows()
	for i,v in pairs({
		PlayerStatusTexture,
		PlayerStatusGlow,
		PlayerRestGlow,
		PlayerRestIcon,
		PlayerAttackGlow,
		PlayerAttackBackground
	}) do 
		v:Hide()
	end
end

-- Remove server name from raid frames

hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
  local inInstance, instanceType = IsInInstance()
  local name = frame.name;
  local xName = GetUnitName(frame.unit, true);
  if (instanceType == "pvp" or instanceType == "arena") then
	if (xName) then
   		local noRealm = gsub(xName, "%-[^|]+", "");
		name:SetText(noRealm);
	end
  end
end);

-- Hide / Show mouseover raidframe

local manager = CompactRaidFrameManager
manager:SetAlpha(0)
local function FindParent(frame, target)
	if frame == target then
		return true
	elseif frame then
		return FindParent(frame:GetParent(), target)
	end
end

manager:HookScript("OnEnter", function(self)
	self:SetAlpha(1)
end)

manager:HookScript("OnLeave", function(self)
	if manager.collapsed and not FindParent(GetMouseFocus(), self) then
		self:SetAlpha(0)
	end
end)

manager.toggleButton:HookScript("OnClick", function()
	if manager.collapsed then
		manager:SetAlpha(0)
	end
end)

manager.container:SetIgnoreParentAlpha(true)
manager.containerResizeFrame:SetIgnoreParentAlpha(true)

-- Class colored health and/or gradient

function GradientColour(statusbar)
    if (not statusbar or statusbar.disconnected) then 
		return 
	end
 
    local min, max = statusbar:GetMinMaxValues();
    if (max <= min) then 
		return 
	end
 
    local value = statusbar:GetValue()
    if ( (value < min) or (value > max) ) then 
		return
	end
 
    value = (value - min) / (max - min);
 
    local r, g
    if(value > 0.5) then
        r = (1.0 - value) * 2;
        g = 1.0;
    else
        r = 1.0;
        g = value * 2;
    end
    statusbar:SetStatusBarColor(r, g, 0.0);

    return
end

local function colour(statusbar, unit)
	if not statusbar then return end

	if unit then
		if UnitIsConnected(unit) and unit == statusbar.unit then
			if UnitIsPlayer(unit) and UnitClass(unit) and RougeUI.ClassHP then
				local _, class = UnitClass(unit)
				local c = RAID_CLASS_COLORS[class]
				if c then statusbar:SetStatusBarColor(c.r, c.g, c.b) end
			elseif (RougeUI.GradientHP and UnitCanAttack("player", unit)) or not RougeUI.ClassHP then
				GradientColour(statusbar)
			elseif (not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
				statusbar:SetStatusBarColor(.5, .5, .5)
			elseif RougeUI.unithp then
				local red, green = UnitSelectionColor(unit)
				if red == 0 then
					statusbar:SetStatusBarColor(0, 1, 0)
				elseif green == 0 then
					statusbar:SetStatusBarColor(1, 0, 0)
				else
					statusbar:SetStatusBarColor(1, 1, 0)
				end
			end
		end
	end
end

local function manabarcolor(statusbar, unit)
	if UnitIsPlayer("player") then
		PlayerFrameManaBar.lockColor = true
		PlayerFrameManaBar:SetStatusBarColor(127/255, 0/255, 255/255)
		if (UnitIsUnit("targettarget", "player")) then
			TargetFrameToTManaBar:SetStatusBarColor(127/255, 0/255, 255/255)
		end
		if (UnitIsUnit("target", "player")) then
			TargetFrameManaBar:SetStatusBarColor(127/255, 0/255, 255/255)
		end
		if (UnitIsUnit("focus", "player")) then
			FocusFrameManaBar:SetStatusBarColor(127/255, 0/255, 255/255)
		end
		if (UnitIsUnit("focus-target", "player")) then
			FocusFrameToTManaBar:SetStatusBarColor(127/255, 0/255, 255/255)
		end
	end
end

-- Transparent name background

hooksecurefunc("TargetFrame_CheckFaction", function(self)
    self.nameBackground:SetVertexColor(0/255, 0/255, 0/255, 0.5);
end)

-- Fix Chain Color

local function FixChain()
	PlayerFrameTexture:SetVertexColor(1, 1, 1)
end

-- Classification

local function CheckClassification(self, forceNormalTexture)

	local classification = UnitClassification(self.unit);

	if (forceNormalTexture) then
		self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
		self.borderTexture:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
	elseif ( classification  == "worldboss" or classification  == "elite" ) then
		self.borderTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Elite")
		self.borderTexture:SetVertexColor(1, 1, 1)
	elseif ( classification  == "rareelite" ) then
		self.borderTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare-Elite")
		self.borderTexture:SetVertexColor(1, 1, 1)
	elseif ( classification  == "rare" ) then
		self.borderTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare")
		self.borderTexture:SetVertexColor(1, 1, 1)
	else
		self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
		self.borderTexture:SetVertexColor(RougeUI.Colval, RougeUI.Colval, RougeUI.Colval)
		forceNormalTexture = true;
	end
end

-- Fix Portrait gaps

local function OnLoad()
	TargetFrameToTPortrait:ClearAllPoints()
	TargetFrameToTPortrait:SetPoint("LEFT", TargetFrameToT, "LEFT", 5, 0)
	FocusFrameToTPortrait:ClearAllPoints()
	FocusFrameToTPortrait:SetPoint("LEFT", FocusFrameToT, "LEFT", 5, 0)
end

-- Class portrait frames

local lastTargetToTGuid = nil
local lastFocusToTGuid = nil
local CP = {}

function CP:CreateToTPortraits()
	if not self.TargetToTPortrait then
		self.TargetToTPortrait = TargetFrameToT:CreateTexture(nil, "ARTWORK")
		self.TargetToTPortrait:SetSize(TargetFrameToT.portrait:GetSize())
		for i=1, TargetFrameToT.portrait:GetNumPoints() do
			self.TargetToTPortrait:SetPoint(TargetFrameToT.portrait:GetPoint(i))
		end
		self.TargetToTPortrait:ClearAllPoints()
		self.TargetToTPortrait:SetPoint("LEFT", TargetFrameToT, "LEFT", 5, 0)
	end

	if not self.FocusToTPortrait then
		self.FocusToTPortrait = FocusFrameToT:CreateTexture(nil, "ARTWORK")
		self.FocusToTPortrait:SetSize(FocusFrameToT.portrait:GetSize())
		for i=1, FocusFrameToT.portrait:GetNumPoints() do
			self.FocusToTPortrait:SetPoint(FocusFrameToT.portrait:GetPoint(i))
		end
		self.FocusToTPortrait:ClearAllPoints()
		self.FocusToTPortrait:SetPoint("LEFT", TargetFrameToT, "LEFT", 5, 0)
	end
end

local CLASS_TEXTURE = "Interface\\AddOns\\RougeUI\\textures\\classes\\%s.blp"

local function ClassPortrait(self)
	if self.unit == "player" or self.unit == "pet" then
		return
	end

	if self.portrait and not (self.unit == "targettarget" or self.unit == "focus-target") then
		if UnitIsPlayer(self.unit) then
			local _, class = UnitClass(self.unit)
			if (class and UnitIsPlayer(self.unit)) then
				self.portrait:SetTexture(CLASS_TEXTURE:format(class))
			else
				format(self.unit)
			end
		end
	end

	if UnitExists("targettarget") ~= nil then
		if UnitGUID("targettarget") ~= lastTargetToTGuid then
			lastTargetToTGuid = UnitGUID("targettarget")
			if UnitIsPlayer("targettarget") then
				local _, class = UnitClass("targettarget")
				CP.TargetToTPortrait:SetTexture(CLASS_TEXTURE:format(class))
				CP.TargetToTPortrait:Show()
			else
				CP.TargetToTPortrait:Hide()
			end
		end
	else
		CP.TargetToTPortrait:Hide()
		lastTargetToTGuid = nil
	end

	if UnitExists("focus-target") ~= nil then
		if UnitGUID("focus-target") ~= lastFocusToTGuid then
			lastFocusToTGuid = UnitGUID("focus-target")
			if UnitIsPlayer("focus-target") then
				local _, class = UnitClass("focus-target")
				CP.FocusToTPortrait:SetTexture(CLASS_TEXTURE:format(class))
				CP.FocusToTPortrait:Show()
			else
				CP.FocusToTPortrait:Hide()
			end
		end
	else
		CP.FocusToTPortrait:Hide()
		lastFocusToTGuid = nil
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

local events = {
	"PLAYER_LOGIN",
	"PLAYER_ENTERING_WORLD",
	"ZONE_CHANGED_NEW_AREA"
}

local e = CreateFrame("Frame")
for _, v in pairs(events) do e:RegisterEvent(v) end
e:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then

		if RougeUI.TimerGap then
			if not (IsAddOnLoaded("SeriousBuffTimers") or IsAddOnLoaded("BuffTimers")) then
				hooksecurefunc("AuraButton_UpdateDuration", TimeFormat)
			end
		end

		if (RougeUI.ClassHP or RougeUI.GradientHP or RougeUI.unithp) then
			hooksecurefunc("UnitFrameHealthBar_Update", colour)
			hooksecurefunc("HealthBar_OnValueChanged", function(self)
				if not self:IsForbidden() then
					colour(self, self.unit)
				end
			end)
		end
		if RougeUI.Class_Portrait then
			CP:CreateToTPortraits()
			hooksecurefunc("UnitFramePortrait_Update", ClassPortrait)
		end
		if RougeUI.ScoreBoard then
			hooksecurefunc("WorldStateScoreFrame_Update", ColorScoreBoard)
		end
		if RougeUI.HideGlows then
			hooksecurefunc(PlayerHitIndicator, "Show", PlayerHitIndicator.Hide)
			hooksecurefunc(PetHitIndicator, "Show", PetHitIndicator.Hide)
			hooksecurefunc("PlayerFrame_UpdateStatus", HideGlows)
		end
		if RougeUI.HideTitles then
			hooksecurefunc(PlayerFrameGroupIndicator, "Show", PlayerFrameGroupIndicator.Hide)
			hooksecurefunc("CompactRaidGroup_GenerateForGroup", HideFrameTitles)
			hooksecurefunc("CompactPartyFrame_Generate", HideFrameTitles)
		end
		if RougeUI.pimp then
			hooksecurefunc("UnitFrameManaBar_Update", manabarcolor)
		end
		if RougeUI.HideAggro then
			hooksecurefunc("CompactUnitFrame_UpdateAggroHighlight", function(self)
				if self.aggroHighlight then
					self.aggroHighlight:Hide()
					return
				end
			end)
		end

		for addons in pairs(addonlist) do
			if IsAddOnLoaded(addons) then
				self:UnregisterEvent("PLAYER_LOGIN")
				return
			end
		end

		OnLoad()

		if RougeUI.Colval < 0.16 then
			hooksecurefunc("TargetFrame_CheckClassification", CheckClassification)
		end
	end

	if ((event == "PLAYER_ENTERING_WORLD") and RougeUI.FadeIcon == true) then
		PvPIcon()
	elseif (RougeUI.FadeIcon == false) then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end

	if ((event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA") and RougeUI.SQFix == true) then
		SpellQueueFix()
	elseif RougeUI.SQFix == false then
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end

	self:UnregisterEvent("PLAYER_LOGIN")
end);
