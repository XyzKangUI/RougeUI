local _, RougeUI = ...
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local IsAddOnLoaded = IsAddOnLoaded
local GetSpellInfo = GetSpellInfo
local GetNetStats = GetNetStats
local IsInInstance = IsInInstance
local GetBattlefieldScore = GetBattlefieldScore
local UnitClass, UnitExists, UnitHealth, UnitCanAttack, GetUnitName = UnitClass, UnitExists, UnitHealth, UnitCanAttack, GetUnitName
local UnitIsPlayer, UnitPlayerControlled, UnitIsUnit, UnitClassification = UnitIsPlayer, UnitPlayerControlled, UnitIsUnit, UnitClassification
local UnitIsConnected, UnitSelectionColor, UnitIsTapDenied, UnitPlayerControlled = UnitIsConnected, UnitSelectionColor, UnitIsTapDenied, UnitPlayerControlled
local ConsoleExec, RAID_CLASS_COLORS = ConsoleExec, RAID_CLASS_COLORS
local gsub, format = string.gsub, string.format
local GetClassColorObj, GetMouseFocus = GetClassColorObj, GetMouseFocus

local addonlist = {
    ["EasyFrames"] = true,
    ["whoaThickFrames_WotLK"] = true,
    ["whoaUnitFrames_WotLK"] = true,
    ["TextureScript"] = true,
    ["SUI"] = true,
    ["RiizUI"] = true
}

-- Hide MultiGroupFrame icons showing as Party(+BG) leader
local mg = PlayerPlayTime:GetParent().MultiGroupFrame
hooksecurefunc(mg, "Show", mg.Hide)

-- Remove gap in buff timers & color the format
local function TimeFormat(button, time)
    local duration = _G[button:GetName() .. "Duration"]
    local floor, fmod = math.floor, math.fmod
    local h, m, s, text

    if time <= 0 then
        text = ""
    elseif time < 3600 and time > 60 then
        h = floor(time / 3600)
        m = floor(fmod(time, 3600) / 60 + 1)
        s = fmod(time, 60)
        text = duration:SetFormattedText("|r%d|rm", m)
    elseif time > 5 and time < 60 then
        m = floor(time / 60)
        s = fmod(time, 60)
        if RougeUI.db.Roug or RougeUI.db.Modern then
            text = m == 0 and duration:SetFormattedText("|r%d|r", s)
        else
            text = m == 0 and duration:SetFormattedText("|r%d|rs", s)
        end
    elseif time < 5 then
        m = floor(time / 60)
        s = fmod(time, 60)
        if RougeUI.db.Roug or RougeUI.db.Modern then
            text = m == 0 and duration:SetFormattedText("|r%.1f|r", s)
        else
            text = m == 0 and duration:SetFormattedText("|r%d|rs", s)
        end
    else
        h = floor(time / 3600 + 1)
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
        frame = _G["CompactRaidGroup" .. groupIndex .. "Title"]
    end

    if frame then
        frame:SetAlpha(0)
    end
end

-- Class colored scoreboard
local function ColorScoreBoard()
    local inInstance, instanceType = IsInInstance()
    if (instanceType ~= "pvp") then
        return
    end
    for i = 1, 22 do
        local ScoreBoard = _G["WorldStateScoreButton" .. i]

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
    for i, v in pairs({
        PlayerPVPIcon,
        FocusFrameTextureFramePVPIcon,
        TargetFrameTextureFramePVPIcon,
        TargetFrameTextureFramePVPIcon,
        PartyMemberFrame1PVPIcon,
        PartyMemberFrame2PVPIcon,
        PartyMemberFrame3PVPIcon,
        PartyMemberFrame4PVPIcon
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
hooksecurefunc("PlayerFrame_UpdatePvPStatus", FixPvPFrame)

-- Hide indicators and fancy glows

local function HideGlows()
    for _, v in pairs({
        PlayerStatusTexture,
        PlayerStatusGlow,
        PlayerRestGlow,
        PlayerRestIcon,
        PlayerAttackGlow,
        PlayerAttackBackground
    }) do
        if v:IsShown() then
            v:Hide()
        end
    end
end

-- Remove server name from raid frames

hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
    local inInstance, instanceType = IsInInstance()
    local name = frame.name
    local xName = GetUnitName(frame.unit, true)
    if (instanceType == "pvp" or instanceType == "arena") then
        if (xName) then
            local noRealm = gsub(xName, "%-[^|]+", "")
            name:SetText(noRealm)
        end
    end
end)

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

function RougeUI.RougeUIF:GradientColour(statusbar)
    if (not statusbar or statusbar.disconnected) then
        return
    end

    local min, max = statusbar:GetMinMaxValues()
    if (max <= min) then
        return
    end

    local value = statusbar:GetValue()
    if ((value < min) or (value > max)) then
        return
    end

    value = (value - min) / (max - min)

    local r, g
    if (value > 0.5) then
        r = (1.0 - value) * 2
        g = 1.0
    else
        r = 1.0
        g = value * 2
    end
    statusbar:SetStatusBarColor(r, g, 0.0)

    return
end

local function colour(statusbar, unit)
    if not statusbar then
        return
    end

    if unit then
        if UnitIsConnected(unit) and unit == statusbar.unit then
            if UnitIsPlayer(unit) and UnitClass(unit) and RougeUI.db.ClassHP then
                local _, class = UnitClass(unit)
                local c = RAID_CLASS_COLORS[class]
                if c then
                    statusbar:SetStatusBarColor(c.r, c.g, c.b)
                end
            elseif (RougeUI.db.GradientHP and UnitCanAttack("player", unit)) or not (RougeUI.db.ClassHP or RougeUI.db.unithp) then
                RougeUI.RougeUIF:GradientColour(statusbar)
            elseif RougeUI.db.unithp then
                local red, green = UnitSelectionColor(unit)
                if red == 0 then
                    statusbar:SetStatusBarColor(0, 1, 0)
                elseif green == 0 then
                    statusbar:SetStatusBarColor(1, 0, 0)
                else
                    statusbar:SetStatusBarColor(1, 1, 0)
                end
            elseif (not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
                statusbar:SetStatusBarColor(.5, .5, .5)
            end
        end
    end
end

local function manabarcolor(statusbar, unit)
    if statusbar and unit then
        local r, g, b = 0.49803921568, 0, 1.0
        PlayerFrameManaBar:SetStatusBarColor(r, g, b)
        if (statusbar == PlayerFrameManaBar) and not statusbar.lockColor then
            statusbar.lockColor = true -- taint?
        end
        if (UnitIsUnit("targettarget", "player")) then
            TargetFrameToTManaBar:SetStatusBarColor(r, g, b)
        end
        if (UnitIsUnit("target", "player")) then
            TargetFrameManaBar:SetStatusBarColor(r, g, b)
        end
        if (UnitIsUnit("focus", "player")) then
            FocusFrameManaBar:SetStatusBarColor(r, g, b)
        end
        if (UnitIsUnit("focustarget", "player")) then
            FocusFrameToTManaBar:SetStatusBarColor(r, g, b)
        end
    end
end

-- Backup if lockColor taints
local PowerBarColors = {};
PowerBarColors["MANA"] = { r = 0.49803921568, g = 0, b = 1.0 };
PowerBarColors["RAGE"] = { r = 0.49803921568, g = 0, b = 1.0 };
PowerBarColors["FOCUS"] = { r = 0.49803921568, g = 0, b = 1.0 };
PowerBarColors["ENERGY"] = { r = 0.49803921568, g = 0, b = 1.0 };
PowerBarColors["RUNIC_POWER"] = { r = 0.49803921568, g = 0, b = 1.0 };

local function ZunitFrame(manaBar)
    local unitFrame = manaBar:GetParent();

    if (not manaBar) or not (unitFrame == PlayerFrame) then
        return ;
    end
    local powerType, powerToken, altR = UnitPowerType(manaBar.unit);
    local prefix = _G[powerToken];
    local info = PowerBarColors[powerToken];
    if info then
        if (not manaBar.lockColor) then
            local playerDeadOrGhost = manaBar.unit == "player" and (UnitIsDead("player") or UnitIsGhost("player")) and not UnitIsFeignDeath("player");
            if not info.atlas and not playerDeadOrGhost then
                manaBar:SetStatusBarColor(info.r, info.g, info.b);
            end
        end
    else
        if (not altR) then
            info = PowerBarColors[powerType] or PowerBarColors["MANA"];
        end
    end
end

-- Classification

local classificationTexture = {
    ["worldboss"] = {
        ["thin"] = "Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Elite",
        ["thick"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite",
        ["thick2"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite2",
        ["nthin"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Elite",
        ["nthin2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Elite2",
        ["nthick"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Elite",
        ["nthick2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Elite2",
    },
    ["rareelite"] = {
        ["thin"] = "Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare-Elite",
        ["thick"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-RareElite",
        ["thick2"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-RareElite2",
        ["nthin"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Rare-Elite",
        ["nthin2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Rare-Elite2",
        ["nthick"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-RareElite",
        ["nthick2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-RareElite2",
    },
    ["elite"] = {
        ["thin"] = "Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Elite",
        ["thick"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite",
        ["thick2"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite2",
        ["nthin"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Elite",
        ["nthin2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Elite2",
        ["nthick"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Elite",
        ["nthick2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Elite2",
    },
    ["rare"] = {
        ["thin"] = "Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare",
        ["thick"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Rare",
        ["thick2"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Rare2",
        ["nthin"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Rare",
        ["nthin2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Rare2",
        ["nthick"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Rare",
        ["nthick2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Rare2",
    },
}

local function FrameTexture(frame, classification)
    local textureName, textureType = "", ""

    if classification then
        if classificationTexture[classification] then
            if RougeUI.db.ThickFrames and (RougeUI.db.Colval >= 0.3) then
                if RougeUI.db.NoLevel then
                    textureName = classificationTexture[classification]["nthick2"]
                    textureType = "nthick2"
                else
                    textureName = classificationTexture[classification]["thick2"]
                    textureType = "thick2"
                end
            elseif RougeUI.db.ThickFrames then
                if RougeUI.db.NoLevel then
                    textureName = classificationTexture[classification]["nthick"]
                    textureType = "nthick"
                else
                    textureName = classificationTexture[classification]["thick"]
                    textureType = "thick"
                end
            else
                if RougeUI.db.NoLevel then
                    if (RougeUI.db.Colval >= 0.3) then
                        textureName = classificationTexture[classification]["nthin2"]
                        textureType = "nthin2"
                    else
                        textureName = classificationTexture[classification]["nthin"]
                        textureType = "nthin"
                    end
                else
                    textureName = classificationTexture[classification]["thin"]
                    textureType = "thin"
                end
            end
            if (RougeUI.db.Colval >= 0.3) then
                frame:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
            else
                frame:SetVertexColor(1, 1, 1)
            end
        end
    end

    if textureName == "" then
        if RougeUI.db.ThickFrames then
            if RougeUI.db.NoLevel then
                textureName = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-TargetingFrame"
            else
                textureName = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-TargetingFrame"
            end
        else
            if RougeUI.db.NoLevel then
                textureName = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame"
            else
                textureName = "Interface\\TargetingFrame\\UI-TargetingFrame"
            end
        end
        if RougeUI.db.NoLevel then
            textureType = "nthin"
        else
            textureType = "thin"
        end
        frame:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
    end
    frame:SetTexture(textureName)
end

local function CheckClassification(self, forceNormalTexture)
    local classification = UnitClassification(self.unit)
    local textureName = ""

    FrameTexture(self.borderTexture, classification)

    if textureName == "" then
        forceNormalTexture = true
    end

    if RougeUI.db.ClassNames then
        local _, class = UnitClass(self.unit)
        local c = RAID_CLASS_COLORS[class]
        if c and UnitIsPlayer(self.unit) then
            self.name:SetVertexColor(c.r, c.g, c.b)
        else
            self.name:SetVertexColor(1, 0.81960791349411, 0, 1)
        end
    end

    if RougeUI.db.NoLevel then
        self.levelText:SetAlpha(0)
        self.threatIndicator:SetTexture("Interface\\AddOns\\RougeUI\\textures\\nolevel\\ui-targetingframe-flash")
    end

    if RougeUI.db.ThickFrames then
        self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0, 0)
        self.nameBackground:Hide()
        self.name:ClearAllPoints()
        self.name:SetPoint("CENTER", self, "CENTER", -50, 35)
        self.name:SetFontObject("SystemFont_Outline_Small")
        self.name:SetShadowOffset(0, 0)

        self.healthbar:ClearAllPoints()
        self.healthbar:SetPoint("CENTER", self, "CENTER", -50, 14)
        self.healthbar:SetHeight(27)
        self.healthbar.LeftText:ClearAllPoints()
        self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 7, 0)
        self.healthbar.RightText:ClearAllPoints()
        self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -4, 0)
        self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)

        self.deadText:ClearAllPoints()
        self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)

        self.manabar:ClearAllPoints()
        self.manabar:SetPoint("CENTER", self, "CENTER", -50, -7)

        self.manabar.LeftText:ClearAllPoints()
        self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 7, 0)
        self.manabar.RightText:ClearAllPoints()
        self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -4, 0)
        self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0)

        if GetCVar("threatShowNumeric") == "1" then
            TargetFrameNumericalThreat:SetScale(0.9)
            TargetFrameNumericalThreat:ClearAllPoints()
            TargetFrameNumericalThreat:SetPoint("CENTER", TargetFrame, "CENTER", 44, 50)
            FocusFrameNumericalThreat:ClearAllPoints()
            FocusFrameNumericalThreat:SetPoint("CENTER", FocusFrame, "CENTER", 44, 48)
        end

        if (forceNormalTexture) then
            self.haveElite = nil
            self.Background:SetSize(119, 42)
            self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35)
        else
            self.haveElite = true
            self.Background:SetSize(119, 42)
        end
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

local CLASS_TEXTURE = "Interface\\AddOns\\RougeUI\\textures\\classes\\%s.blp"

local function ClassPortrait(self)
    if self.unit == "player" or self.unit == "pet" then
        return
    end

    if self.portrait and UnitIsPlayer(self.unit) then
        local _, class = UnitClass(self.unit)
        if class then
            self.portrait:SetTexture(CLASS_TEXTURE:format(class))
        end
    else
        format(self.unit)
    end
end

local function SpellQueueFix()
    local _, _, latencyHome, latencyWorld = GetNetStats()
    local _, class = UnitClass("player")
    local value, currentLatency

    if (latencyHome or latencyWorld) == 0 then
        C_Timer.After(40, SpellQueueFix)
        return
    end

    if latencyHome >= latencyWorld then
        currentLatency = latencyHome
    elseif latencyWorld > latencyHome then
        currentLatency = latencyWorld
    end

    if class == "ROGUE" then
        value = 200 + currentLatency
        ConsoleExec("SpellQueueWindow " .. value)
    elseif class ~= "ROGUE" then
        value = 250 + currentLatency
        ConsoleExec("SpellQueueWindow " .. value)
    end
end

local function HideHotkeys()
    if RougeUI.db.HideHotkey then
        for i = 1, 12 do
            _G["ActionButton" .. i .. "HotKey"]:SetAlpha(0)
            _G["MultiBarBottomRightButton" .. i .. "HotKey"]:SetAlpha(0)
            _G["MultiBarBottomLeftButton" .. i .. "HotKey"]:SetAlpha(0)
            _G["MultiBarRightButton" .. i .. "HotKey"]:SetAlpha(0)
            _G["MultiBarLeftButton" .. i .. "HotKey"]:SetAlpha(0)
        end
    end
    if RougeUI.db.HideMacro then
        for i = 1, 12 do
            _G["ActionButton" .. i .. "Name"]:SetAlpha(0)
            _G["MultiBarBottomRightButton" .. i .. "Name"]:SetAlpha(0)
            _G["MultiBarBottomLeftButton" .. i .. "Name"]:SetAlpha(0)
            _G["MultiBarRightButton" .. i .. "Name"]:SetAlpha(0)
            _G["MultiBarLeftButton" .. i .. "Name"]:SetAlpha(0)
        end
    end
end

local function PlayerArtThick(self)
    local classification

    if RougeUI.db.NoLevel then
        PlayerLevelText:Hide()
    end

    if RougeUI.db.ClassNames then
        local _, class = UnitClass("player")
        local c = RAID_CLASS_COLORS[class]
        if c then
            self.name:SetVertexColor(c.r, c.g, c.b)
        end
    end

    if RougeUI.db.RareElite then
        classification = "rareelite"
    elseif RougeUI.db.GoldElite then
        classification = "elite"
    elseif RougeUI.db.Rare then
        classification = "rare"
    end
    FrameTexture(PlayerFrameTexture, classification)

    if RougeUI.db.ThickFrames then
        self.name:ClearAllPoints()
        self.name:SetPoint("CENTER", self, "CENTER", 50, 35)
        self.name:SetFontObject("SystemFont_Outline_Small")
        self.name:SetShadowOffset(0, 0)
        self.healthbar:ClearAllPoints()
        self.healthbar:SetPoint("CENTER", self, "CENTER", 50, 14)
        self.healthbar:SetHeight(27)
        self.healthbar.LeftText:ClearAllPoints()
        self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 7, 0)
        self.healthbar.RightText:ClearAllPoints()
        self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -4, 0)
        self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
        self.manabar:ClearAllPoints()
        self.manabar:SetPoint("CENTER", self, "CENTER", 50, -7)
        self.manabar:SetHeight(13)
        self.manabar.LeftText:ClearAllPoints()
        self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 7, 0)
        self.manabar.RightText:ClearAllPoints()
        self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -4, 0)
        self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0)
    end
end

local function VehicleArtThick(self, vehicleType)
    if (vehicleType == "Natural") then
        PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Organic")
        PlayerFrameFlash:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Organic-Flash")
        PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86)
        self.healthbar:SetSize(103, 12)
        self.healthbar:SetPoint("TOPLEFT", 116, -41)
        self.manabar:SetSize(103, 12)
        self.manabar:SetPoint("TOPLEFT", 116, -52)
    else
        PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame")
        PlayerFrameFlash:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Flash")
        PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86)
        self.healthbar:SetSize(100, 12)
        self.healthbar:SetPoint("TOPLEFT", 119, -41)
        self.manabar:SetSize(100, 12)
        self.manabar:SetPoint("TOPLEFT", 119, -52)
    end
end

local function PetArtThick()
    PetFrameTexture:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\UI-SmallTargetingFrame")
    PetName:SetAlpha(0)
    PetFrameHealthBar:SetHeight(13)
    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint("CENTER", PetFrame, "CENTER", 16, 5)
    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("CENTER", PetFrame, "CENTER", 16, -7)
    PetFrameHealthBar.TextString:ClearAllPoints()
    PetFrameHealthBar.TextString:SetPoint("CENTER", PetFrameHealthBar, "CENTER", 0, -0.5)
    PetFrameManaBar.TextString:ClearAllPoints()
    PetFrameManaBar.TextString:SetPoint("CENTER", PetFrameManaBar, "CENTER", 0, 0)
    PetFrameHealthBarTextLeft:ClearAllPoints()
    PetFrameHealthBarTextLeft:SetPoint("TOPLEFT", 45, -18)
    PetFrameHealthBarTextRight:ClearAllPoints()
    PetFrameHealthBarTextRight:SetPoint("TOPRIGHT", -14, -18)
    PetFrameManaBarTextLeft:ClearAllPoints()
    PetFrameManaBarTextLeft:SetPoint("LEFT", 45, -7)
    PetFrameManaBarTextRight:ClearAllPoints()
    PetFrameManaBarTextRight:SetPoint("RIGHT", -14, -7)
end

local function ApplyThickness()
    PlayerFrame.name:ClearAllPoints()
    PlayerFrame.name:SetPoint("TOP", PlayerFrameHealthBar, 0, 15)
    PlayerStatusTexture:SetTexture()
    PlayerRestGlow:SetAlpha(0)
    hooksecurefunc(PlayerFrameGroupIndicator, "Show", PlayerFrameGroupIndicator.Hide)
    hooksecurefunc("PlayerFrame_ToVehicleArt", VehicleArtThick)
    hooksecurefunc("PetFrame_Update", PetArtThick)
    hooksecurefunc("PlayerFrame_UpdateStatus", HideGlows)
end

local events = {
    "PLAYER_LOGIN",
    "PLAYER_ENTERING_WORLD",
    "ZONE_CHANGED_NEW_AREA"
}

local function GetActionButton(slot)
    local name

    local bonusBar = GetBonusBarOffset()
    local slotID = (1 + (NUM_ACTIONBAR_PAGES + bonusBar - 1) * NUM_ACTIONBAR_BUTTONS)
    if (bonusBar == 0 and slot <= 12) or (bonusBar > 0 and slot >= slotID and slot < (slotID + 12)) then
        name = "ACTIONBUTTON" .. (((slot - 1) % 12) + 1)
    elseif slot <= 36 then
        name = "MULTIACTIONBAR3BUTTON" .. (slot - 24)
    elseif slot <= 48 then
        name = "MULTIACTIONBAR4BUTTON" .. (slot - 36)
    elseif slot <= 60 then
        name = "MULTIACTIONBAR2BUTTON" .. (slot - 48)
    elseif slot <= 72 then
        name = "MULTIACTIONBAR1BUTTON" .. (slot - 60)
    elseif IsAddOnLoaded("Bartender4") and slot >= 1 and slot <= 120 then
        name = "CLICK BT4Button" .. slot .. ":Keybind"
    elseif IsAddOnLoaded("Dominos") and slot >= 1 and slot <= 120 then
        name = "CLICK DominosActionButton" .. slot .. ":HOTKEY"
    elseif slot <= 144 then
        name = nil
    elseif slot <= 156 then
        name = "MULTIACTIONBAR5BUTTON" .. (slot - 144)
    elseif slot <= 168 then
        name = "MULTIACTIONBAR6BUTTON" .. (slot - 156)
    elseif slot <= 180 then
        name = "MULTIACTIONBAR7BUTTON" .. (slot - 168)
    elseif slot <= 192 then
        name = "MULTIACTIONBAR8BUTTON" .. (slot - 180)
    end

    return name
end

local function Haxx()
    local slots = C_ActionBar.FindSpellActionButtons(6774)
    if slots then
        for _, slot in ipairs(slots) do
            local actionButton = GetActionButton(slot)
            if actionButton then
                local key = GetBindingKey(actionButton)
                if string.match(actionButton, "^ACTIONBUTTON%d+$") then
                    print("RougeUI: For the Slice and Dice hax to work, place your unmodified Slice and Dice spell in any other slot than the (stealth) actionbar.")
                    return
                end
                if key then
                    local button = CreateFrame("Button", "FSND", nil, "SecureActionButtonTemplate")
                    button:RegisterForClicks("AnyDown", "AnyUp")
                    button:SetAttribute("type", "macro")
                    SecureHandlerWrapScript(button, "OnClick", button, [[ if down then
                    self:SetAttribute("macrotext","/cast Slice and Dice") else
                    self:SetAttribute("macrotext","/cast [@focus, exists] Slice and Dice") end]])
                    SetOverrideBindingClick(button, true, key, "FSND")
                end
            end
        end
    elseif slots == nil then
        print("Can't find Slice and Dice on the actionbar or this actionbar is unsupported")
    end
end

local e = CreateFrame("Frame")
for _, v in pairs(events) do
    e:RegisterEvent(v)
end
e:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then

        if RougeUI.db.ThickFrames then
            ApplyThickness()
        end

        if RougeUI.db.NoLevel or RougeUI.db.ThickFrames or RougeUI.db.GoldElite or RougeUI.db.RareElite or RougeUI.db.Rare or RougeUI.db.ClassNames then
            hooksecurefunc("PlayerFrame_ToPlayerArt", PlayerArtThick)
        end

        if RougeUI.db.TimerGap or RougeUI.db.Lorti or RougeUI.db.Roug or RougeUI.db.Modern then
            if not (IsAddOnLoaded("SeriousBuffTimers") or IsAddOnLoaded("BuffTimers")) then
                hooksecurefunc("AuraButton_UpdateDuration", TimeFormat)
            end
        end

        if (RougeUI.db.ClassHP or RougeUI.db.GradientHP or RougeUI.db.unithp) then
            hooksecurefunc("UnitFrameHealthBar_Update", colour)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                if not self:IsForbidden() then
                    colour(self, self.unit)
                end
            end)
        end
        if RougeUI.db.Class_Portrait then
            hooksecurefunc("UnitFramePortrait_Update", ClassPortrait)
        end
        if RougeUI.db.ScoreBoard then
            hooksecurefunc("WorldStateScoreFrame_Update", ColorScoreBoard)
        end
        if RougeUI.db.HideGlows then
            hooksecurefunc("PlayerFrame_UpdateStatus", HideGlows)
        end
        if RougeUI.db.HideIndicator then
            hooksecurefunc(PlayerHitIndicator, "Show", PlayerHitIndicator.Hide)
            hooksecurefunc(PetHitIndicator, "Show", PetHitIndicator.Hide)
        end
        if RougeUI.db.HideTitles then
            hooksecurefunc(PlayerFrameGroupIndicator, "Show", PlayerFrameGroupIndicator.Hide)
            hooksecurefunc("CompactRaidGroup_GenerateForGroup", HideFrameTitles)
            hooksecurefunc("CompactPartyFrame_Generate", HideFrameTitles)
            --PlayerLeaderIcon:SetAlpha(0)
            --TargetFrameTextureFrameLeaderIcon:SetAlpha(0)
            --TargetFrameTextureFrameLeaderIcon:SetAlpha(0)
            --FocusFrameTextureFrameLeaderIcon:SetAlpha(0)
        end
        if RougeUI.db.pimp then
            hooksecurefunc("UnitFrameManaBar_Update", manabarcolor)
            -- hooksecurefunc("UnitFrameManaBar_UpdateType", ZunitFrame)
        end
        if RougeUI.db.HideAggro then
            hooksecurefunc("CompactUnitFrame_UpdateAggroHighlight", function(self)
                if self.aggroHighlight then
                    self.aggroHighlight:SetAlpha(0)
                    return
                end
            end)
        end
        if RougeUI.db.roleIcon then
            hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", function(frame)
                if not frame.roleIcon then
                    return ;
                end

                if frame.roleIcon:IsShown() and (frame.roleIcon:GetAlpha() > 0) then
                    frame.roleIcon:SetAlpha(0);
                end
            end)
        end
        if RougeUI.db.Stance then
            local stancebar = CreateFrame("Frame", nil, UIParent)
            stancebar:Hide()
            StanceBarFrame:UnregisterAllEvents()
            StanceBarFrame:SetParent(stancebar)
        end

        if not RougeUI.db.ThickFrames and (RougeUI.db.ClassBG or RougeUI.db.transparent) then
            hooksecurefunc("TargetFrame_CheckFaction", function(self)
                if RougeUI.db.ClassBG and UnitIsPlayer(self.unit) then
                    local _, class = UnitClass(self.unit)
                    local c = RAID_CLASS_COLORS[class]
                    if c then
                        self.nameBackground:SetVertexColor(c.r, c.g, c.b)
                    end
                else
                    self.nameBackground:SetVertexColor(0, 0, 0, 0.5)
                end
            end)
        end

        if RougeUI.db.ClassBG then
            if PlayerFrame:IsShown() and not PlayerFrame.bg then
                local c = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
                local bg = PlayerFrame:CreateTexture()
                bg:SetPoint("TOPLEFT", PlayerFrameBackground)
                bg:SetPoint("BOTTOMRIGHT", PlayerFrameBackground, 0, 22)
                bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
                if c then
                    bg:SetVertexColor(c.r, c.g, c.b)
                end
                PlayerFrame.bg = true
            end
            TargetFrameNameBackground:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
            FocusFrameNameBackground:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
        end

        if RougeUI.db.AutoReady then
            ReadyCheckFrame:HookScript("OnShow", function(self)
                ReadyCheckFrameYesButton:Click()
            end)
            QueueReadyCheckPopup:HookScript("OnShow", function(self)
                QueueReadyCheckPopup.YesButton:Click()
            end)
        end
        if RougeUI.db.BuffAlpha then
            hooksecurefunc("AuraButton_OnUpdate", function(self)
                self:SetAlpha(1)
            end)
        end

        if RougeUI.db.Slice then
            Haxx()
        end

        for addons in pairs(addonlist) do
            if IsAddOnLoaded(addons) then
                self:UnregisterEvent("PLAYER_LOGIN")
                return
            end
        end

        OnLoad()

        if RougeUI.db.ThickFrames or RougeUI.db.NoLevel or (RougeUI.db.Colval < 0.3)  or RougeUI.db.ClassNames then
            hooksecurefunc("TargetFrame_CheckClassification", CheckClassification)
        end
    end

    if event == "PLAYER_ENTERING_WORLD" then
        if RougeUI.db.FadeIcon then
            PvPIcon()
        end

        if RougeUI.db.SQFix then
            SpellQueueFix()
        end

        if RougeUI.db.HideHotkey or RougeUI.db.HideMacro then
            HideHotkeys()
        end

        if not RougeUI.db.FadeIcon and not RougeUI.db.SQFix and not RougeUI.db.HideHotkey and not RougeUI.db.HideMacro then
            self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end

    if event == "ZONE_CHANGED_NEW_AREA" and RougeUI.db.SQFix then
        SpellQueueFix()
    else
        self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
    end

    self:UnregisterEvent("PLAYER_LOGIN")
end)