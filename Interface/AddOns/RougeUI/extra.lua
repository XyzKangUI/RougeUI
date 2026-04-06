local addonName, RougeUI = ...
local pairs, gsub = pairs, string.gsub
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
local IsInInstance, IsDesaturated, GetActionCooldown = IsInInstance, IsDesaturated, GetActionCooldown
local UnitClass, UnitExists, UnitCanAttack, GetUnitName = UnitClass, UnitExists, UnitCanAttack, GetUnitName
local UnitIsPlayer, UnitPlayerControlled, UnitIsUnit, UnitClassification = UnitIsPlayer, UnitPlayerControlled, UnitIsUnit, UnitClassification
local UnitIsConnected, UnitSelectionColor, UnitIsTapDenied = UnitIsConnected, UnitSelectionColor, UnitIsTapDenied
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local isClassicEra = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC

-- Hide MultiGroupFrame icons showing as Party(+BG) leader
local mg = PlayerPlayTime:GetParent().MultiGroupFrame
hooksecurefunc(mg, "Show", mg.Hide)

-- Hide Raid frame titles
local function HideFrameTitles(groupIndex)
    local frame

    if groupIndex and groupIndex > 0 then
        frame = _G["CompactRaidGroup" .. groupIndex .. "Title"]
    else
        frame = _G["CompactPartyFrameTitle"]
    end

    if frame then
        frame:SetAlpha(0)
    end
end

-- Class colored scoreboard
local function ColorScoreBoard()
    local _, instanceType = IsInInstance()
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
                if isClassicEra and (filename == "SHAMAN") then
                    color = CreateColor(0.0, 0.44, 0.87)
                end
                ScoreBoard.name.text:SetText(color:WrapTextInColorCode(text))
            end
        end
    end
end

-- Some PvPIcon tweaks for BG/Arena/CP Classes

function RougeUI.PvPIcon()
    local _, instanceType = IsInInstance()
    for i, v in pairs({
        PlayerPVPIcon,
        TargetFrameTextureFramePVPIcon,
        TargetFrameTextureFramePVPIcon,
        PartyMemberFrame1PVPIcon,
        PartyMemberFrame2PVPIcon,
        PartyMemberFrame3PVPIcon,
        PartyMemberFrame4PVPIcon
    }) do
        if instanceType == "arena" then
            v:SetAlpha(0)
            if FocusFrame then
                FocusFrameTextureFramePVPIcon:SetAlpha(0)
            end
        else
            local opacity = RougeUI.db.FadePvPIcon or 0.45
            v:SetAlpha(opacity)
            if FocusFrame then
                FocusFrameTextureFramePVPIcon:SetAlpha(opacity)
            end
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
    local _, instanceType = IsInInstance()
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
    local focus = GetMouseFoci()[1]
    if not focus then
        return
    end
    if manager.collapsed and not FindParent(focus, self) then
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
                    if isClassicEra and class == "SHAMAN" then
                        statusbar:SetStatusBarColor(0.0, 0.44, 0.87)
                    else
                        statusbar:SetStatusBarColor(c.r, c.g, c.b)
                    end
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

local function manabarRecolor(manaBar)
    if not manaBar or not UnitIsUnit(manaBar.unit, "player") then
        return
    end

    if not manaBar.lockColor then
        local playerDeadOrGhost = manaBar.unit == "player" and (UnitIsDead("player") or UnitIsGhost("player")) and not UnitIsFeignDeath("player")
        if not playerDeadOrGhost then
            local c = RougeUI.db.ManaBarColor
            if c then
                manaBar:SetStatusBarColor(c.r, c.g, c.b, c.a)
            end
        end
    end
end

-- Classification

local classificationTexture = {
    ["worldboss"] = {
        ["og"] = "Interface\\TargetingFrame\\UI-TargetingFrame-Elite",
        ["thin"] = "Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Elite",
        ["thick"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite",
        ["thick2"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite2",
        ["nthin"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Elite",
        ["nthin2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Elite2",
        ["nthick"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Elite",
        ["nthick2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Elite2",
    },
    ["rareelite"] = {
        ["og"] = "Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite",
        ["thin"] = "Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Rare-Elite",
        ["thick"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-RareElite",
        ["thick2"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-RareElite2",
        ["nthin"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Rare-Elite",
        ["nthin2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Rare-Elite2",
        ["nthick"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-RareElite",
        ["nthick2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-RareElite2",
    },
    ["elite"] = {
        ["og"] = "Interface\\TargetingFrame\\UI-TargetingFrame-Elite",
        ["thin"] = "Interface\\AddOns\\RougeUI\\textures\\target\\UI-TargetingFrame-Elite",
        ["thick"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite",
        ["thick2"] = "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-Elite2",
        ["nthin"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Elite",
        ["nthin2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame-Elite2",
        ["nthick"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Elite",
        ["nthick2"] = "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-Elite2",
    },
    ["rare"] = {
        ["og"] = "Interface\\TargetingFrame\\UI-TargetingFrame-Rare",
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
    local textureName = ""

    if RougeUI.db.AsuriFrame then
        frame:SetTexture("Interface\\AddOns\\RougeUI\\textures\\target\\AsuriFrame")
        frame:SetVertexColor(RougeUI.db.Colval, RougeUI.db.Colval, RougeUI.db.Colval)
        return
    end

    if classification and classificationTexture[classification] then
        if RougeUI.db.ThickFrames and (RougeUI.db.Colval >= 0.3) then
            textureName = RougeUI.db.NoLevel and classificationTexture[classification]["nthick2"] or classificationTexture[classification]["thick2"]
        elseif RougeUI.db.ThickFrames then
            textureName = RougeUI.db.NoLevel and classificationTexture[classification]["nthick"] or classificationTexture[classification]["thick"]
        else
            if RougeUI.db.NoLevel then
                textureName = (RougeUI.db.Colval >= 0.3) and classificationTexture[classification]["nthin2"] or classificationTexture[classification]["nthin"]
            else
                if RougeUI.db.Colval >= 0.3 then
                    textureName = classificationTexture[classification]["og"]
                else
                    textureName = classificationTexture[classification]["thin"]
                end
            end
        end
        frame:SetVertexColor((RougeUI.db.Colval >= 0.3) and RougeUI.db.Colval or 1, (RougeUI.db.Colval >= 0.3) and RougeUI.db.Colval or 1, (RougeUI.db.Colval >= 0.3) and RougeUI.db.Colval or 1)
    end

    if textureName == "" then
        if RougeUI.db.ThickFrames then
            textureName = RougeUI.db.NoLevel and "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-Thick-TargetingFrame" or "Interface\\AddOns\\RougeUI\\textures\\target\\Thick-TargetingFrame"
        else
            textureName = RougeUI.db.NoLevel and "Interface\\AddOns\\RougeUI\\textures\\nolevel\\NoLevel-UI-TargetingFrame" or "Interface\\TargetingFrame\\UI-TargetingFrame"
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

    if RougeUI.db.NoLevel and not RougeUI.db.AsuriFrame then
        self.levelText:SetAlpha(0)
        if self.threatIndicator then
            self.threatIndicator:SetTexture("Interface\\AddOns\\RougeUI\\textures\\nolevel\\ui-targetingframe-flash")
        end
        if isClassicEra and IsAddOnLoaded("ModernTargetFrame") then
            for i = 1, TargetFrame:GetNumRegions() do
                local region = select(i, TargetFrame:GetRegions())
                if region:IsObjectType("Texture") and not region:GetName() then
                    local r, g, b, a = region:GetVertexColor()
                    if r == 1 and g == 0 and b == 0 and a == 1 then
                        region:SetTexture("Interface\\AddOns\\RougeUI\\textures\\nolevel\\ui-targetingframe-flash")
                    end
                end
            end
        end
    end

    if RougeUI.db.ThickFrames then
        self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0, 0)
        self.nameBackground:Hide()
        self.name:ClearAllPoints()
        self.name:SetPoint("CENTER", self, "CENTER", -30, 35)
        self.name:SetFontObject("SystemFont_Outline_Small")
        self.name:SetShadowOffset(0, 0)

        self.healthbar:ClearAllPoints()
        self.healthbar:SetPoint("CENTER", self, "CENTER", -33, 12)
        self.healthbar:SetHeight(27)
        if self.healthbar.LeftText then
            self.healthbar.LeftText:ClearAllPoints()
            self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 7, 0)
        end
        if self.healthbar.RightText then
            self.healthbar.RightText:ClearAllPoints()
            self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -4, 0)
        end
        if self.healthbar.TextString then
            self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
        end

        if self.deadText then
            self.deadText:ClearAllPoints()
            self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
        end

        self.manabar:ClearAllPoints()
        self.manabar:SetPoint("CENTER", self, "CENTER", -33, -10)

        if self.manabar.LeftText then
            self.manabar.LeftText:ClearAllPoints()
            self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 7, 0)
        end
        if self.manabar.RightText then
            self.manabar.RightText:ClearAllPoints()
            self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -4, 0)
        end
        if self.manabar.TextString then
            self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0)
        end

        if GetCVar("threatShowNumeric") == "1" then
            if TargetFrameNumericalThreat then
                TargetFrameNumericalThreat:SetScale(0.9)
                TargetFrameNumericalThreat:ClearAllPoints()
                TargetFrameNumericalThreat:SetPoint("CENTER", TargetFrame, "CENTER", 44, 50)
            end
            if FocusFrame and FocusFrameNumericalThreat then
                FocusFrameNumericalThreat:ClearAllPoints()
                FocusFrameNumericalThreat:SetPoint("CENTER", FocusFrame, "CENTER", 44, 48)
            end
        end

        if (forceNormalTexture) then
            self.haveElite = nil
            self.Background:SetSize(119, 42)
            self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", -89.5, -27)
        else
            self.haveElite = true
            self.Background:SetSize(119, 42)
            self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", -89.5, -27)
        end
    elseif RougeUI.db.AsuriFrame then
        self.highLevelTexture:SetAlpha(0)
        self.nameBackground:SetAlpha(0)
        self.levelText:SetAlpha(0)
        if self.threatIndicator then
            self.threatIndicator:SetAlpha(0)
        end
        self.name:ClearAllPoints()
        self.name:SetPoint("CENTER", self, "CENTER", -30, 25)
        self.name:SetShadowOffset(1, -1)

        self.healthbar:ClearAllPoints()
        self.healthbar:SetPoint("CENTER", self, "CENTER", -33, 4)
        self.healthbar:SetHeight(16)
        if self.healthbar.LeftText then
            self.healthbar.LeftText:ClearAllPoints()
            self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 7, 0)
        end
        if self.healthbar.RightText then
            self.healthbar.RightText:ClearAllPoints()
            self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -4, 0)
        end
        if self.healthbar.TextString then
            self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
        end

        if self.deadText then
            self.deadText:ClearAllPoints()
            self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
        end

        self.manabar:ClearAllPoints()
        self.manabar:SetPoint("CENTER", self, "CENTER", -33, -10)

        if self.manabar.LeftText then
            self.manabar.LeftText:ClearAllPoints()
            self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 7, -1)
        end
        if self.manabar.RightText then
            self.manabar.RightText:ClearAllPoints()
            self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -4, -1)
        end
        if self.manabar.TextString then
            self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, -1)
        end
        if (forceNormalTexture) then
            self.haveElite = nil
            self.Background:SetSize(119, 30)
            self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", -89.5, -39)
        else
            self.haveElite = true
            self.Background:SetSize(119, 30)
        end
    else
        self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", -89.5, -42)
    end
end

-- Fix Portrait gaps
local function OnLoad()
    TargetFrameToTPortrait:ClearAllPoints()
    TargetFrameToTPortrait:SetPoint("LEFT", TargetFrameToT, "LEFT", 5, 0)
    if FocusFrame then
        FocusFrameToTPortrait:ClearAllPoints()
        FocusFrameToTPortrait:SetPoint("LEFT", FocusFrameToT, "LEFT", 5, 0)
        FocusFrameToTBackground:SetPoint("BOTTOMLEFT", 44, 15) -- tmp
    end
    TargetFrameToTBackground:SetPoint("BOTTOMLEFT", 44, 15) -- tmp
end

-- Class portrait frames

local CLASS_TEXTURE = "Interface\\AddOns\\RougeUI\\textures\\classes\\%s.blp"

local function OverlayPortrait(parent)
    local layer, level = parent.portrait:GetDrawLayer()
    local texture = parent:CreateTexture(nil, layer, nil, level + 1)
    texture:SetSize(parent.portrait:GetSize())
    for i = 1, parent.portrait:GetNumPoints() do
        texture:SetPoint(parent.portrait:GetPoint(i))
    end
    texture:ClearAllPoints()
    texture:SetPoint("CENTER", parent.portrait, "CENTER")
    return texture
end

local function UpdatePortrait(self)
    local unit, texture = self.unit, self.overlayPortrait
    local unitExists, unitGuid = UnitExists(unit), UnitGUID(unit)
    local _, class = UnitClass(unit)

    if unitExists and unitGuid ~= self.lastGuid then
        self.lastGuid = unitGuid
        if UnitIsPlayer(unit) and class then
            texture:SetTexture(CLASS_TEXTURE:format(class))
            texture:Show()
        else
            texture:Hide()
        end
    elseif not unitExists then
        texture:Hide()
        self.lastGuid = nil
    end
end

local function ClassPortrait(self)
    if self.unit == "pet" then
        return
    end

    if self.portrait and (self.unit == "player" or UnitInVehicle("player")) then
        local _, class = UnitClass(self.unit)
        if class then
            self.portrait:SetTexture(CLASS_TEXTURE:format(class))
        end
        return
    end

    if not self.overlayPortrait and self.portrait then
        self.overlayPortrait = OverlayPortrait(self)
    end

    if self.overlayPortrait then
        UpdatePortrait(self)
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

local buttonNames = { "ActionButton", "MultiBarBottomRightButton", "MultiBarBottomLeftButton",
                      "MultiBarRightButton", "MultiBarLeftButton", "PetActionButton" }

local function HideHotkeys()
    for _, buttonName in pairs(buttonNames) do
        for i = 1, 12 do
            local hotKey = _G[buttonName .. i .. "HotKey"]
            if hotKey and RougeUI.db.HideHotkey then
                hotKey:SetAlpha(0)
            end
            local name = _G[buttonName .. i .. "Name"]
            if name and RougeUI.db.HideMacro then
                name:SetAlpha(0)
            end
        end
    end
end

local function PlayerArtThick(self)
    local classification

    if RougeUI.db.NoLevel or RougeUI.db.AsuriFrame then
        PlayerLevelText:Hide()
    end

    if RougeUI.db.RareElite then
        classification = "rareelite"
    elseif RougeUI.db.GoldElite then
        classification = "elite"
    elseif RougeUI.db.Rare then
        classification = "rare"
    end

    if RougeUI.db.AsuriFrame and classification then
        if not AsuriChain then
            local asuriChain = PlayerFrameTexture:GetParent():CreateTexture("AsuriChain", "BORDER", nil, 1)
            if classification == "rare" or classification == "rareelite" then
                asuriChain:SetTexture("Interface\\Addons\\RougeUI\\textures\\target\\ChainAsuri")
            else
                asuriChain:SetTexture("Interface\\Addons\\RougeUI\\textures\\target\\ChainAsuriGold")
            end
            asuriChain:SetTexCoord(1, 0, 0, 1)
            asuriChain:SetSize(256, 128)
            asuriChain:SetPoint("CENTER", PlayerFrame, "CENTER", 0, -17)
            asuriChain:Show()
        elseif not AsuriChain:IsShown() then
            AsuriChain:Show()
        end
    end
    FrameTexture(PlayerFrameTexture, classification)
    if not RougeUI.db.AsuriFrame then
        PlayerFrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
        PlayerFrameTexture:SetPoint("TOPLEFT", PlayerFrame.rightFrame.textFrame, "TOPLEFT", -17, -3)
        PlayerFrameTexture:SetSize(232, 99)
    end

    if RougeUI.db.ThickFrames then
        self.name:ClearAllPoints()
        self.name:SetPoint("CENTER", self, "CENTER", 30, 35)
        self.name:SetFontObject("SystemFont_Outline_Small")
        self.name:SetShadowOffset(0, 0)
        self.healthbar:ClearAllPoints()
        self.healthbar:SetPoint("CENTER", self, "CENTER", 33, 11)
        self.healthbar:SetHeight(27)
        if self.healthbar.LeftText then
            self.healthbar.LeftText:ClearAllPoints()
            self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 7, 0)
        end
        if self.healthbar.RightText then
            self.healthbar.RightText:ClearAllPoints()
            self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -4, 0)
        end
        self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
        self.ManaBar:ClearAllPoints()
        self.ManaBar:SetPoint("CENTER", self, "CENTER", 33, -10)
        if self.ManaBar.LeftText then
            self.ManaBar.LeftText:ClearAllPoints()
            self.ManaBar.LeftText:SetPoint("LEFT", self.ManaBar, "LEFT", 7, 0)
        end
        if self.ManaBar.RightText then
            self.ManaBar.RightText:ClearAllPoints()
            self.ManaBar.RightText:SetPoint("RIGHT", self.ManaBar, "RIGHT", -4, 0)
        end
        self.ManaBar.TextString:SetPoint("CENTER", self.ManaBar, "CENTER", 0, 0)
    elseif RougeUI.db.AsuriFrame then
        self.name:SetAlpha(0)
        PlayerFrameBackground:SetSize(119, 29)
        PlayerFrameBackground:SetPoint("TOPLEFT", 87, -38)
        self.healthbar:ClearAllPoints()
        self.healthbar:SetPoint("CENTER", self, "CENTER", 33, 4) -- -20, -3
        self.healthbar:SetHeight(16)

        if self.healthbar.LeftText then
            self.healthbar.LeftText:ClearAllPoints()
            self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 7, 0)
        end
        if self.healthbar.RightText then
            self.healthbar.RightText:ClearAllPoints()
            self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -4, 0)
        end
        self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
        self.manabar:ClearAllPoints()
        self.manabar:SetPoint("CENTER", self, "CENTER", 33, -10)
        if self.manabar.LeftText then
            self.manabar.LeftText:ClearAllPoints()
            self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 7, -1)
        end
        if self.manabar.RightText then
            self.manabar.RightText:ClearAllPoints()
            self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -4, -1)
        end
        self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, -1)
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

    if AsuriChain and AsuriChain:IsShown() then
        AsuriChain:Hide()
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
    if PetFrameHealthBarTextLeft then
        PetFrameHealthBarTextLeft:ClearAllPoints()
        PetFrameHealthBarTextLeft:SetPoint("TOPLEFT", 45, -18)
    end
    if PetFrameHealthBarTextRight then
        PetFrameHealthBarTextRight:ClearAllPoints()
        PetFrameHealthBarTextRight:SetPoint("TOPRIGHT", -14, -18)
    end
    if PetFrameManaBarTextLeft then
        PetFrameManaBarTextLeft:ClearAllPoints()
        PetFrameManaBarTextLeft:SetPoint("LEFT", 45, -7)
    end
    if PetFrameManaBarTextRight then
        PetFrameManaBarTextRight:ClearAllPoints()
        PetFrameManaBarTextRight:SetPoint("RIGHT", -14, -7)
    end
    if PetFrameBackgroundTexture then
        PetFrameBackgroundTexture:SetHeight(21) -- tmp
    end
end

local function ApplyThickness()
    if not RougeUI.db.AsuriFrame then
        PlayerFrame.name:ClearAllPoints()
        PlayerFrame.name:SetPoint("TOP", PlayerFrameHealthBar, 0, 15)
        PlayerStatusTexture:SetTexture("Interface\\Addons\\RougeUI\\textures\\target\\UI-Player-Status2");
    end
    PlayerRestGlow:SetAlpha(0)
    hooksecurefunc(PetFrame, "Update", PetArtThick)
    hooksecurefunc(PlayerFrameGroupIndicator, "Show", PlayerFrameGroupIndicator.Hide)
    hooksecurefunc("PlayerFrame_ToVehicleArt", VehicleArtThick)
end

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
    elseif IsAddOnLoaded("Dominos") and slot >= 1 and slot <= 168 then
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
                    button:SetAttribute("pressAndHoldAction", "1")
                    button:SetAttribute("typerelease", "macro")
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

local IsUsableAction, GetActionCount, IsConsumableAction = IsUsableAction, GetActionCount, IsConsumableAction
local IsStackableAction, IsActionInRange, RANGE_INDICATOR = IsStackableAction, IsActionInRange, RANGE_INDICATOR

local function Usable(button)

end

local function RangeIndicator(button)
    if not button or not button:IsVisible() then
        return
    end

    local action = button.action
    local icon   = button.icon

    if not action or not icon then
        return
    end

    local inRange = IsActionInRange(action)
    if inRange == false then
        icon:SetVertexColor(1.0, 0.35, 0.35, 0.75)
        icon:SetDesaturated(true)
        return
    end

    if button:GetName():match("PetActionButton%d") then
        icon:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        icon:SetDesaturated(false)
        return
    end

    --local start, duration, enable = GetActionCooldown(action)
    --local onCooldown = enable == 1 and start > 0 and duration > 1
    --
    --if onCooldown then
    --    icon:SetVertexColor(0.4, 0.4, 0.4, 1.0)
    --    icon:SetDesaturated(true)
    --    return
    --end

    local isUsable, notEnoughMana = IsUsableAction(action)
    local count = GetActionCount(action)

    if isUsable then
        icon:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        icon:SetDesaturated(false)

    elseif notEnoughMana then
        icon:SetVertexColor(0.3, 0.3, 0.3, 1.0)
        icon:SetDesaturated(true)

    elseif (IsConsumableAction(action) or IsStackableAction(action)) and count == 0 then
        icon:SetDesaturated(true)

    else
        if UnitExists("target") or UnitExists("focus") then
            icon:SetVertexColor(0.4, 0.4, 0.4, 1.0)
            icon:SetDesaturated(true)
        else
            icon:SetVertexColor(1.0, 1.0, 1.0, 1.0)
            icon:SetDesaturated(false)
        end
    end
end

local conflictingAddons = {
    ["BuffSizer"] = true, -- aura override
    ["ClassicAuraDurations"] = true, -- aura conflict
    ["Lorti-UI-Classic"] = true, -- new maintainer, no idea about future conflicts
    ["DarkModeUI"] = true, -- some sort of Lorti
    ["EasyFrames"] = true, -- multiple overrides
    ["LargerSelfAuras"] = true, -- aura override
    ["RiizUI"] = true, -- aura override
    ["TextureScript"] = true, -- RIP
    ["SUI"] = true, -- tainty/override
    ["whoaUnitFrames_WotLK"] = true, -- overrides
    ["whoaThickFrames_WotLK"] = true, -- overrides
    ["BetterBlizzFrames"] = true, -- aura override. Use Precognito for absorbs and DebuffFilter for aura customization.
    ["mUI"] = true, -- -- tainty/override
    ["ResistUI"] = true, -- lots of taints
    ["Dragonheir"] = true, -- blue shaman taint
    ["xBlueShaman"] = true, -- blue shaman taint
    ["whoaBlueShamans"] = true, -- blue shaman taint
    ["GoodmanUI"] = true,
    ["TargetDebuffs"] = true, -- aura override
    ["modui_classic"] = true, -- outdated and broken
}

local disabledAddonsList = {}

StaticPopupDialogs["INCOMPATIBLE_ADDONS"] = {
    text = "",
    button1 = "Reload UI",
    OnAccept = function()
        ReloadUI()
    end,
    OnShow = function(self)
        local addonList = table.concat(disabledAddonsList, ", ")
        self.Text:SetText("Incompatible addons detected: " .. addonList .. "\nClick reload or ESC to continue.")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local e = CreateFrame("Frame")
e:RegisterEvent("PLAYER_LOGIN")
e:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if (RougeUI.db.FadePvPIcon < 100) or RougeUI.db.SQFix or RougeUI.db.HideHotkey or RougeUI.db.HideMacro then
            self:RegisterEvent("PLAYER_ENTERING_WORLD")
        end

        if RougeUI.db.SQFix then
            self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        end
        
        if ComboFrame then
            ComboFrame:SetParent(TargetFrame)
        end

        if WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC and not IsAddOnLoaded("Precognito") then
            for _, v in pairs { PlayerFrameHealthBar, TargetFrameHealthBar, FocusFrameHealthBar } do
                if v and v.MyHealPredictionBar then
                    v.MyHealPredictionBar.FillMask:SetTexture("Interface\\TargetingFrame\\UI-StatusBar", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
                end
                if v and v.OtherHealPredictionBar then
                    v.OtherHealPredictionBar.FillMask:SetTexture("Interface\\TargetingFrame\\UI-StatusBar", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
                end
            end
        end

        do
            for i = 1, C_AddOns.GetNumAddOns() do
                local name, _, _, _, state = C_AddOns.GetAddOnInfo(i)
                if conflictingAddons[name] and state ~= "DISABLED" then
                    C_AddOns.DisableAddOn(i)
                    table.insert(disabledAddonsList, name)
                end
            end

            if #disabledAddonsList > 0 then
                StaticPopup_Show("INCOMPATIBLE_ADDONS")
            end
        end

        if RougeUI.db.ToTDebuffs then
            for _, totFrame in ipairs({ TargetFrameToT, FocusFrameToT }) do
                -- totFrame:HookScript("OnShow", function()
                for i = 1, 4 do
                    local dbf = _G[totFrame:GetName() .. "Debuff" .. i]
                    if dbf and dbf:GetAlpha() > 0 then
                        dbf:SetAlpha(0)
                    end
                end
            end
            -- end)
        end

        if RougeUI.db.ThickFrames or RougeUI.db.AsuriFrame then
            ApplyThickness()
        end

        if RougeUI.db.AsuriFrame then
            local hideToTName, hideFoTName
            hooksecurefunc(TargetFrameToT.name, "SetText", function(self)
                if hideToTName then
                    return
                end
                hideToTName = true
                self:SetText("")
                hideToTName = false
            end)
            if FocusFrameToT then
                hooksecurefunc(FocusFrameToT.name, "SetText", function(self)
                    if hideFoTName then
                        return
                    end
                    hideFoTName = true
                    self:SetText("")
                    hideFoTName = false
                end)
            end
            hooksecurefunc(TargetFrameNameBackground, "Show", TargetFrameNameBackground.Hide)
            if FocusFrameNameBackground then
                hooksecurefunc(FocusFrameNameBackground, "Show", FocusFrameNameBackground.Hide)
            end
        end

        if RougeUI.db.ClassNames then
            hooksecurefunc("UnitFrame_Update", function(self)
                if not self.unit or not self.name then
                    return
                end

                local _, class = UnitClass(self.unit)
                local c = RAID_CLASS_COLORS[class]
                if c and UnitIsPlayer(self.unit) then
                    local txtFont, txtSize, outline = self.name:GetFont()
                    if outline ~= "OUTLINE" then
                        self.name:SetFont(txtFont, txtSize, "OUTLINE")
                    end
                    if class == "SHAMAN" then
                        self.name:SetTextColor(0.0, 0.44, 0.87)
                    else
                        self.name:SetTextColor(c.r, c.g, c.b)
                    end
                else
                    self.name:SetTextColor(1, 0.81960791349411, 0)
                end
            end)
        end

        if RougeUI.db.NoLevel or RougeUI.db.ThickFrames or RougeUI.db.AsuriFrame or RougeUI.db.GoldElite or RougeUI.db.RareElite or RougeUI.db.Rare then
            hooksecurefunc("PlayerFrame_ToPlayerArt", PlayerArtThick)
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
        if RougeUI.db.HideGlows or RougeUI.db.AsuriFrame then
            hooksecurefunc("PlayerFrame_UpdateStatus", HideGlows)
        end
        if RougeUI.db.HideIndicator then
            hooksecurefunc(PlayerHitIndicator, "Show", PlayerHitIndicator.Hide)
            hooksecurefunc(PetHitIndicator, "Show", PetHitIndicator.Hide)
        end
        if RougeUI.db.HideTitles then
            if not RougeUI.db.ThickFrames or not RougeUI.db.AsuriFrame then
                hooksecurefunc(PlayerFrameGroupIndicator, "Show", PlayerFrameGroupIndicator.Hide)
            end
            hooksecurefunc("CompactRaidGroup_GenerateForGroup", HideFrameTitles)
            hooksecurefunc("CompactPartyFrame_Generate", HideFrameTitles)
            for i = 0, 8 do
                HideFrameTitles(i)
            end
        end
        if RougeUI.db.pimp then
            hooksecurefunc("UnitFrameManaBar_UpdateType", manabarRecolor)
        end
        if RougeUI.db.HideAggro then
            if CompactUnitFrame_UpdateAggroHighlight then
                hooksecurefunc("CompactUnitFrame_UpdateAggroHighlight", function(self)
                    if self.aggroHighlight and (self.aggroHighlight:GetAlpha() > 0) then
                        self.aggroHighlight:SetAlpha(0)
                        return
                    end
                end)
            end
        end
        if RougeUI.db.roleIcon then
            hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", function(frame)
                if not frame.roleIcon then
                    return
                end

                if frame.roleIcon:IsShown() and (frame.roleIcon:GetAlpha() > 0) then
                    frame.roleIcon:SetAlpha(0);
                end
            end)
        end
        if RougeUI.db.Stance and StanceBar then
            local stancebar = CreateFrame("Frame", nil, UIParent)
            stancebar:Hide()
            StanceBar:UnregisterAllEvents()
            StanceBar:SetParent(stancebar)
        end

        if (not RougeUI.db.ThickFrames or not RougeUI.db.AsuriFrame) and (RougeUI.db.ClassBG or RougeUI.db.transparent) then
            local function customNamebackground(self)
                if RougeUI.db.ClassBG and UnitIsPlayer(self.unit) then
                    local _, class = UnitClass(self.unit)
                    local c = RAID_CLASS_COLORS[class]
                    if c then
                        if isClassicEra and class == "SHAMAN" then
                            self.nameBackground:SetVertexColor(0.0, 0.44, 0.87)
                        else
                            self.nameBackground:SetVertexColor(c.r, c.g, c.b)
                        end
                    end
                else
                    self.nameBackground:SetVertexColor(0, 0, 0, 0.5)
                end
            end
            hooksecurefunc(TargetFrame, "CheckFaction", customNamebackground)
            if FocusFrame then
                hooksecurefunc(FocusFrame, "CheckFaction", customNamebackground)
            end
        end

        if RougeUI.db.ClassBG and not RougeUI.db.AsuriFrame then
            if PlayerFrame:IsShown() and not PlayerFrame.bg then
                local _, class = UnitClass("player")
                local c = RAID_CLASS_COLORS[class]
                local bg = PlayerFrame:CreateTexture()
                bg:SetPoint("TOPLEFT", PlayerFrameBackground)
                bg:SetPoint("BOTTOMRIGHT", PlayerFrameBackground, 0, 22)
                bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
                if c then
                    if isClassicEra and class == "SHAMAN" then
                        bg:SetVertexColor(0.0, 0.44, 0.87)
                    else
                        bg:SetVertexColor(c.r, c.g, c.b)
                    end
                end
                PlayerFrame.bg = true
            end
            TargetFrameNameBackground:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
            if FocusFrame then
                FocusFrameNameBackground:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
            end
        end

        if RougeUI.db.AutoReady then
            ReadyCheckFrame:HookScript("OnShow", function(self)
                ReadyCheckFrameYesButton:Click()
            end)
        end
        if RougeUI.db.BuffAlpha then
            for _, aura in ipairs({BuffFrame.AuraContainer:GetChildren()}) do
                if aura and aura.SetAlpha then
                    local overflowBuffs
                    hooksecurefunc(aura, "SetAlpha", function(self)
                        if overflowBuffs then return end
                        overflowBuffs = true
                        self:SetAlpha(1)
                        overflowBuffs = false
                    end)
                end
            end
            for _, aura in ipairs({DebuffFrame.AuraContainer:GetChildren()}) do
                if aura and aura.SetAlpha then
                    local overflowDebuffs
                    hooksecurefunc(aura, "SetAlpha", function(self)
                        if overflowDebuffs then return end
                        overflowDebuffs = true
                        self:SetAlpha(1)
                        overflowDebuffs = false
                    end)
                end
            end
        end

        if RougeUI.db.Slice then
            Haxx()
        end

        if RougeUI.db.RangeIndicator and not (IsAddOnLoaded("Bartender4") or IsAddOnLoaded("tullaRange")) then
            ActionBarButtonUpdateFrame:SetScript("OnUpdate", nil)
            ActionBarButtonEventsFrame:HookScript("OnUpdate", function(self)
                for _, btn in pairs(self.frames) do
                    RangeIndicator(btn)
                end
            end)
        end

        if RougeUI.db.HidePetText then
            if PetFrameHealthBarText then
                PetFrameHealthBarText:SetAlpha(0)
            end
            if PetFrameManaBarText then
                PetFrameManaBarText:SetAlpha(0)
            end
        end

        OnLoad()

        --tmp
        local PetBG = PetFrame:CreateTexture("PetFrameBackgroundTexture", "BACKGROUND")
        PetBG:SetSize(69, 15)
        PetBG:SetPoint("BOTTOMLEFT", PetFrame, "BOTTOMLEFT", 44, 15)
        PetBG:SetColorTexture(0, 0, 0, 0.5)

        if RougeUI.db.ThickFrames or RougeUI.db.AsuriFrame or RougeUI.db.NoLevel or (RougeUI.db.Colval < 0.3) then
            hooksecurefunc(TargetFrame, "CheckClassification", CheckClassification)
            if FocusFrame then
                hooksecurefunc(FocusFrame, "CheckClassification", CheckClassification)
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if RougeUI.db.FadePvPIcon < 100 then
            RougeUI.PvPIcon()
        end

        if RougeUI.db.SQFix then
            SpellQueueFix()
        end

        if RougeUI.db.HideHotkey or RougeUI.db.HideMacro then
            HideHotkeys()
        end
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        SpellQueueFix()
    end
end)