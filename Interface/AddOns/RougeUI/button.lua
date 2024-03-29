local _, RougeUI = ...
local ceil, mod, floor = _G.math.ceil, _G.math.fmod, _G.math.floor
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
local dominos = IsAddOnLoaded("Dominos")
local bartender4 = IsAddOnLoaded("Bartender4")

local backdrop = {
    bgFile = nil,
    edgeFile = "Interface\\AddOns\\RougeUI\\textures\\art\\outer_shadow",
    tile = false,
    tileSize = 32,
    edgeSize = 6,
    insets = {
        left = 6,
        right = 6,
        top = 6,
        bottom = 6,
    },
}

local function addBorder(button, drawLayer, dbf)

    local name = button:GetName() or "nil"
    local icon = _G[name .. "Icon"]
    local border

    if name and name:match("Debuff") then
        button.debuff = true
    elseif name and name:match("TempEnchant") then
        button.tempenchant = true
    elseif name and name:match("Buff") then
        button.buff = true
    end

    if icon then
        icon:SetDrawLayer("BACKGROUND", -8)
    end

    if button.debuff or button.tempenchant then
        border = _G[name .. "Border"]
    else
        border = button:CreateTexture(nil, drawLayer or "BACKGROUND")
    end

    local stealable = _G[name .. "Stealable"]
    local customStealable = false

    if button and border then
        if RougeUI.db.Lorti then
            if button.debuff and dbf then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss2")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss")
                customStealable = true
            end
        elseif RougeUI.db.Roug then
            if button.debuff then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\debuff")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\rouge")
                customStealable = true
            end
        elseif RougeUI.db.Modern then
            if button.debuff then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\expdebuff")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\exp")
                customStealable = true
            end
        elseif RougeUI.db.modtheme then
            if button.debuff then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\modd")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\mod")
            end
        end

        if stealable and customStealable then
            --stealable:SetAtlas("newplayertutorial-drag-slotblue") -- doesn't exist on 3.4.0 lets add 2mb
            stealable:SetTexture("Interface\\AddOns\\RougeUI\\textures\\newexp")
            stealable:SetTexCoord(0.338379, 0.412598, 0.680664, 0.829102)
        end

        border:SetTexCoord(0, 1, 0, 1)
        border:SetDrawLayer(drawLayer or "BACKGROUND", 5)
        if not button.debuff then
            border:SetVertexColor(RougeUI.db.BuffVal, RougeUI.db.BuffVal, RougeUI.db.BuffVal)
        end
        border:ClearAllPoints()
        if RougeUI.db.Lorti then
            border:SetAllPoints(button)
        else
            if button.tempenchant then
                border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
                border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
                if RougeUI.db.modtheme then
                    border:SetVertexColor(1, 0, 1)
                elseif RougeUI.db.Modern then
                    border:SetVertexColor(0.7, 0.3, 1)
                end
            else
                border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
                border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
            end
        end
        button.border = border
    end

    -- Lortis shadowy BG
    if (RougeUI.db.Lorti or RougeUI.db.Roug) then
        if RougeUI.db.Roug and button.debuff then
            return
        end
        local bg = CreateFrame("Frame", nil, button, BackdropTemplateMixin and "BackdropTemplate")
        bg:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
        bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)
        bg:SetFrameLevel(max(button:GetFrameLevel() - 1, 0))
        bg:SetBackdrop(backdrop)
        bg:SetBackdropBorderColor(0.05, 0.05, 0.05)
        button.bg = bg
    end
end

local function BtnGlow(button)
    local name = button:GetName()
    local border = _G[name .. "Border"]

    if name and name:match("Debuff") then
        button.debuff = true
    else
        return
    end

    if not button.bg and button.debuff then
        button.bg = CreateFrame("Frame", nil, button, BackdropTemplateMixin and "BackdropTemplate")
        button.bg:SetPoint("TOPLEFT", button, "TOPLEFT", -5, 5)
        button.bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 5, -5)
        button.bg:SetFrameLevel(button:GetFrameLevel() - 1)
        button.bg:SetBackdrop(backdrop)
    end

    if button.debuff and button.bg then
        local r, g, b, a = border:GetVertexColor()
        button.bg:SetBackdropBorderColor(r, g, b, 1)
    end
end

local function TimeFormat(button, time)
    local duration = button.duration
    local h, m, s, text

    if not duration or not time then
        return
    end

    if RougeUI.db.OmniCC then
        if duration and duration:GetAlpha() > 0 then
            local name = button:GetName()
            if name and (name:match("BuffButton") or name:match("DebuffButton") or name:match("TempEnchant")) then
                duration:SetAlpha(0)
            end
        end

        if button.cooldown and (not button.cooldownSet or time >= button.cooldownSet) then
            CooldownFrame_Set(button.cooldown, GetTime(), time, true)
            button.cooldownSet = time
        end
        return
    end

    if time <= 0 then
        text = ""
    elseif time < 3600 and time > 60 then
        h = floor(time / 3600)
        m = floor(mod(time, 3600) / 60 + 0.99)
        s = mod(time, 60)
        if RougeUI.db.modtheme then
            text = duration:SetFormattedText("|cffffffff%d|rm", m)
        else
            text = duration:SetFormattedText("|r%d|rm", m)
        end
    elseif time > 5 and time < 60 then
        m = floor(time / 60)
        s = mod(time, 60)
        if RougeUI.db.Roug or RougeUI.db.Modern then
            text = m == 0 and duration:SetFormattedText("|r%d|r", s)
        else
            if RougeUI.db.modtheme then
                text = m == 0 and duration:SetFormattedText("|cffffffff%d|rs", s)
            else
                text = m == 0 and duration:SetFormattedText("|r%d|rs", s)
            end
        end
    elseif time < 5 then
        m = floor(time / 60)
        s = mod(time, 60)
        if RougeUI.db.Roug or RougeUI.db.Modern then
            text = m == 0 and duration:SetFormattedText("|r%.1f|r", s)
        else
            if RougeUI.db.modtheme then
                text = m == 0 and duration:SetFormattedText("|cffffffff%d|rs", s)
            else
                text = m == 0 and duration:SetFormattedText("|r%d|rs", s)
            end
        end
    else
        h = floor(time / 3600 + 0.99)
        if RougeUI.db.modtheme then
            text = duration:SetFormattedText("|cffffffff%d|rh", h)
        else
            text = duration:SetFormattedText("|r%d|rh", h)
        end
    end

    return text
end

local function SkinBuffs(bu)
    if not bu or (bu and bu.styled) then
        return
    end

    local name = bu:GetName()
    local icon = _G[name .. "Icon"]

    if icon then
        if name:match("Debuff") and not RougeUI.db.Lorti then
            icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
            if RougeUI.db.modtheme then
                icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
                icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            end
        else
            if RougeUI.db.Lorti then
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                icon:ClearAllPoints()
                icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
                icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
                icon:SetDrawLayer("BACKGROUND", -8)
            elseif RougeUI.db.modtheme then
                icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
                icon:ClearAllPoints()
                icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
                icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            else
                icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
            end
        end
    end

    bu:SetNormalTexture("")

    if RougeUI.db.Lorti then
        bu:SetSize(28, 28)
        bu.duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        bu.duration:ClearAllPoints()
        bu.duration:SetPoint("BOTTOM", 1, 0)
    else
        bu.duration:ClearAllPoints()
        bu.duration:SetPoint("CENTER", bu, "BOTTOM", 0, -6.5)
        if RougeUI.db.Roug or RougeUI.db.Modern then
            bu.duration:SetFont(STANDARD_TEXT_FONT, 9.5, "OUTLINE")
            bu.duration:SetShadowOffset(0, 0)
        end
    end

    if bu.count and not RougeUI.db.modtheme then
        bu.count:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
        bu.count:SetShadowOffset(0, 0)
        bu.count:ClearAllPoints()
        bu.count:SetPoint("TOPRIGHT", 1, 0)
    end

    addBorder(bu, "BACKGROUND", true)

    bu.styled = true
end

local function styleActionButton(bu)
    if not bu or (bu and bu.styled) then
        return
    end

    local name = bu:GetName()
    local fbg = _G[name .. "FloatingBG"]
    local fob = _G[name .. "FlyoutBorder"]
    local fobs = _G[name .. "FlyoutBorderShadow"]
    local ic = _G[name .. "Icon"]
    local nt = _G[name .. "NormalTexture"]
    local nt2 = _G[name .. "NormalTexture2"]

    if nt then
        nt:SetTexture(nil)
        nt:SetAlpha(0)
    end
    if nt2 then
        nt2:SetTexture(nil)
        nt2:SetAlpha(0)
    end

    if ic then
        if RougeUI.db.Lorti or RougeUI.db.modtheme then
            ic:SetTexCoord(0, 1, 0, 1)
            if RougeUI.db.Lorti then
                if name and name:match("Stance") then
                    ic:SetTexCoord(0, 1, 0, 1)
                    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
                    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
                else
                    ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
                    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
                end
            end
        else
            ic:SetTexCoord(0.06, 0.94, 0.06, 0.94)
        end
    end

    if fbg then
        fbg:Hide()
    end
    if fob then
        fob:SetTexture(nil)
    end
    if fobs then
        fobs:SetTexture(nil)
    end

    if RougeUI.db.modtheme and bu.border then
        bu.border:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 2)
        bu.border:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 2, -2)
    end

    if RougeUI.db.Lorti then
        bu:SetPushedTexture("Interface\\AddOns\\RougeUI\\textures\\art\\pushed")
    end

    addBorder(bu, "BACKGROUND")

    bu.styled = true
end

local function OmniTimers(buttonName, index, filter)
    local name, _, _, _, duration, expirationTime, buffName, buff

    if index and filter then
        buffName = buttonName .. index
        buff = _G[buffName]
        name, _, _, _, duration, expirationTime = UnitAura("player", index, filter)

        if not name then
            return
        end
    elseif (type(buttonName) == "table" and buttonName:GetName():match("TempEnchant")) then
        buff = buttonName
    else
        return
    end

    if buff and not buff.cooldown then
        local cooldown = CreateFrame("Cooldown", nil, buff, "CooldownFrameTemplate")
        cooldown:SetAllPoints()
        cooldown:SetFrameLevel(buff:GetFrameLevel())
        cooldown:SetReverse(true)
        buff.cooldown = cooldown
    end

    if buff and buff.cooldown and duration then
        CooldownFrame_Set(buff.cooldown, expirationTime - duration, duration, true)
    end
end

local function init()
    -- Actionbars
    for i = 1, 12 do
        styleActionButton(_G["ActionButton" .. i])
        styleActionButton(_G["MultiBarRightButton" .. i])
        styleActionButton(_G["MultiBarLeftButton" .. i])
        styleActionButton(_G["MultiBarBottomLeftButton" .. i])
        styleActionButton(_G["MultiBarBottomRightButton" .. i])
    end

    for i = 1, NUM_PET_ACTION_SLOTS do
        styleActionButton(_G["PetActionButton" .. i])
    end

    for i = 1, 6 do
        styleActionButton(_G["OverrideActionBarButton" .. i])
    end

    if dominos then
        for i = 1, 120 do
            styleActionButton(_G["DominosActionButton" .. i])
        end
    end

    if bartender4 then
        for i = 1, 120 do
            styleActionButton(_G["BT4Button" .. i])
        end
        if GetNumShapeshiftForms() ~= 0 then
            for i = 1, GetNumShapeshiftForms() do
                styleActionButton(_G["BT4StanceButton" .. i])
            end
        end
    end

    for i = 1, 7 do
        local bu = _G["StanceButton" .. i]
        styleActionButton(bu)
    end

    -- Castbar
    local tf = CreateFrame("Frame", nil, TargetFrameSpellBar, BackdropTemplateMixin and "BackdropTemplate")
    addBorder(tf, "OVERLAY")
    tf:SetAllPoints(TargetFrameSpellBar.Icon)
    TargetFrameSpellBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    if FocusFrameSpellBar then
        local ff = CreateFrame("Frame", nil, FocusFrameSpellBar, BackdropTemplateMixin and "BackdropTemplate")
        addBorder(ff, "OVERLAY")
        ff:SetAllPoints(FocusFrameSpellBar.Icon)
        FocusFrameSpellBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end

    -- TempEnchantFrame
    for i = 1, NUM_TEMP_ENCHANT_FRAMES do
        local bu = _G["TempEnchant" .. i]
        if (bu and not bu.styled) then
            SkinBuffs(bu)
            if IsAddOnLoaded("TemporaryWeaponEnchant") and RougeUI.db.modtheme then
                bu.border:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 2)
                bu.border:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 2, -2)
            end
        end
        if RougeUI.db.OmniCC then
            OmniTimers(bu)
        end
    end
end

local function HookAuras()
    hooksecurefunc("TargetFrame_UpdateAuras", function(self)
        local selfName = self:GetName()

        if not self or not selfName then
            return
        end

        for i = 1, 32 do
            local bu = _G[selfName .. "Buff" .. i]
            if bu then
                if not bu.skin then
                    addBorder(bu)
                    local icon = _G[selfName .. "Buff" .. i .. "Icon"]
                    if RougeUI.db.modtheme then
                        icon:SetTexCoord(.03, .97, .03, .97)
                        icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
                        icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
                        bu.border:SetAllPoints(bu)
                    else
                        icon:SetTexCoord(.1, .9, .1, .9)
                    end
                    bu.skin = true
                end
            else
                break
            end
        end

        for i = 1, 16 do
            local bu = _G[selfName .. "Debuff" .. i]
            if bu then
                if not bu.skin then
                    addBorder(bu)
                    local icon = _G[selfName .. "Debuff" .. i .. "Icon"]
                    if RougeUI.db.modtheme then
                        icon:SetTexCoord(.03, .97, .03, .97)
                        icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
                        icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
                    else
                        icon:SetTexCoord(.1, .9, .1, .9)
                    end
                    bu.skin = true
                end
            else
                break
            end
        end
    end)

    if not bartender4 then
        if RougeUI.db.Lorti then
            hooksecurefunc("ActionButton_Update", function(self)
                local action = self.action
                local border = self.Border
                if border then
                    if IsEquippedAction(action) then
                        border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss_grey")
                        border:SetSize(36, 36)
                        border:SetVertexColor(0.499, 0.999, 0.499, 1)
                        border:Show()
                    else
                        border:Hide()
                    end
                end
            end)
        end

        hooksecurefunc("ActionButton_UpdateHotkeys", function(self)
            local hotkey = self.HotKey
            if hotkey then
                hotkey:ClearAllPoints()
                hotkey:SetSize(36, 10)
                if RougeUI.db.Lorti or RougeUI.db.modtheme then
                    hotkey:SetPoint("TOPRIGHT", self, -1, -3)
                    hotkey:SetPoint("TOPLEFT", self, -1, -3)
                else
                    hotkey:SetPoint("TOPLEFT", -2, -2)
                end
            end
        end)
    end
end

local function BuffAnchor()
    local buff, previousBuff, aboveBuff, index
    local numBuffs = 0;
    local numAuraRows = 0;
    local slack = BuffFrame.numEnchants;
    if (BuffFrame.numConsolidated > 0) then
        slack = slack + 1;    -- one icon for all consolidated buffs
    end
    local BUFFS_PER_ROW = RougeUI.db.BuffsRow

    for i = 1, BUFF_ACTUAL_DISPLAY do
        buff = _G["BuffButton" .. i];
        if not buff.consolidated then
            numBuffs = numBuffs + 1;
            index = numBuffs + slack;

            buff:ClearAllPoints();
            if ((index > 1) and (mod(index, BUFFS_PER_ROW) == 1)) then
                -- New row
                numAuraRows = numAuraRows + 1;
                if (index == BUFFS_PER_ROW + 1) then
                    buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "BOTTOMRIGHT", 0, -BUFF_ROW_SPACING - 3); --xx
                else
                    buff:SetPoint("TOPRIGHT", aboveBuff, "BOTTOMRIGHT", 0, -BUFF_ROW_SPACING);
                end
                aboveBuff = buff;
            elseif (index == 1) then
                numAuraRows = 1;
                buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0);
                aboveBuff = buff;
            else
                if (numBuffs == 1) then
                    if (BuffFrame.numEnchants > 0) then
                        buff:SetPoint("TOPRIGHT", "TemporaryEnchantFrame", "TOPLEFT", BUFF_HORIZ_SPACING, 0);
                        aboveBuff = TemporaryEnchantFrame;
                    else
                        buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", BUFF_HORIZ_SPACING, 0);
                    end
                else
                    buff:SetPoint("RIGHT", previousBuff, "LEFT", BUFF_HORIZ_SPACING, 0); -- spacing
                end
            end
            previousBuff = buff;
        end
    end
end

local function DebuffAnchor(buttonName, index)
    local numBuffs = BUFF_ACTUAL_DISPLAY + BuffFrame.numEnchants;
    local BUFFS_PER_ROW = RougeUI.db.BuffsRow

    if (BuffFrame.numConsolidated > 0) then
        numBuffs = numBuffs - BuffFrame.numConsolidated + 1;
    end

    local rows = ceil(numBuffs / BUFFS_PER_ROW);
    local buff = _G[buttonName .. index];
    local offsetY

    buff:ClearAllPoints()
    -- Position debuffs
    if ((index > 1) and (mod(index, BUFFS_PER_ROW) == 1)) then
        -- New row
        buff:SetPoint("TOP", _G[buttonName .. (index - BUFFS_PER_ROW)], "BOTTOM", 0, -BUFF_ROW_SPACING);
    elseif (index == 1) then
        if (rows < 2) then
            offsetY = 1 * ((2 * BUFF_ROW_SPACING) + 30);
        else
            offsetY = rows * (BUFF_ROW_SPACING + 30);
        end
        buff:SetPoint("TOPRIGHT", BuffFrame, "BOTTOMRIGHT", 0, -offsetY);
    else
        buff:SetPoint("RIGHT", _G[buttonName .. (index - 1)], "LEFT", -6, 0);
    end
end

local e3 = CreateFrame("Frame")
e3:RegisterEvent("PLAYER_LOGIN")
e3:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        if not IsAddOnLoaded("SimpleAuraFilter") and (RougeUI.db.BuffsRow and RougeUI.db.BuffsRow < 10) then
            C_Timer.After(1, function()
                hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", BuffAnchor)
                hooksecurefunc("DebuffButton_UpdateAnchors", DebuffAnchor)
            end)
        end

        local skinEnabled = RougeUI.db.Lorti or RougeUI.db.Roug or RougeUI.db.Modern or RougeUI.db.modtheme
        if skinEnabled or RougeUI.db.TimerGap or RougeUI.db.OmniCC then
            if RougeUI.db.OmniCC or not (IsAddOnLoaded("SeriousBuffTimers") or IsAddOnLoaded("BuffTimers")) then
                hooksecurefunc("AuraButton_UpdateDuration", TimeFormat)
            end

            if skinEnabled then
                if (IsAddOnLoaded("Masque") and (dominos or bartender4)) then
                    self:UnregisterEvent("PLAYER_LOGIN")
                    self:SetScript("OnEvent", nil)
                    return
                end

                init()
                HookAuras()
            end

            hooksecurefunc("AuraButton_Update", function(self, index, filter)
                local button = _G[self .. index]
                if button and not button.styled and skinEnabled then
                    SkinBuffs(button)
                end
                if button and RougeUI.db.Roug then
                    BtnGlow(button)
                end

                if RougeUI.db.OmniCC then
                    OmniTimers(self, index, filter)
                end
            end)
        end

        self:UnregisterEvent("PLAYER_LOGIN")
        self:SetScript("OnEvent", nil)
    end
end)
