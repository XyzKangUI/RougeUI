local _, RougeUI = ...
local ceil, mod, floor = _G.math.ceil, _G.math.fmod, _G.math.floor
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local dominos = IsAddOnLoaded("Dominos")
local bartender4 = IsAddOnLoaded("Bartender4")
local isCata = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC)

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
    local icon = _G[name .. "Icon"] or button.Icon
    local border
    local db = RougeUI.db
    local isBuff, isDebuff, isTempEnchant

    if button.auraType == "Buff" then
        isBuff = true
    elseif button.auraType == "Debuff" then
        isDebuff = true
    elseif button.auraType == "TempEnchant" then
        isTempEnchant = true
    end

    local rp = (isBuff or isDebuff or isTempEnchant) and button.Icon or button

    if icon then
        icon:SetDrawLayer("BACKGROUND", -8)
    end

    if isDebuff then
        border = button.DebuffBorder
    elseif isTempEnchant then
        border = button.TempEnchantBorder
    else
        border = button:CreateTexture(nil, drawLayer or "BACKGROUND")
    end

    local stealable = _G[name .. "Stealable"]
    local customStealable = false

    if button and border then
        if db.Lorti then
            if isDebuff and dbf then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss2")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss")
            end
        elseif db.Roug then
            if isDebuff then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\debuff")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\rouge")
                customStealable = true
            end
        elseif db.Modern then
            if isDebuff then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\expdebuff")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\exp")
                customStealable = true
            end
        elseif db.modtheme then
            if isDebuff then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\modd")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\mod")
            end
        end

        if stealable and customStealable and not IsAddOnLoaded("DeBuffFilter") and (db.BuffSizer or db.HighlightDispellable) then
            if C_Texture and C_Texture.GetAtlasInfo("newplayertutorial-drag-slotblue") then
                stealable:SetAtlas("newplayertutorial-drag-slotblue")
            else
                stealable:SetTexture("Interface\\AddOns\\RougeUI\\textures\\newexp")
                stealable:SetTexCoord(0.338379, 0.412598, 0.680664, 0.829102)
            end
        end

        border:SetTexCoord(0, 1, 0, 1)
        border:SetDrawLayer(drawLayer and drawLayer or "BACKGROUND", 5)
        if not isDebuff then
            border:SetVertexColor(db.BuffVal, db.BuffVal, db.BuffVal)
        end
        border:ClearAllPoints()
        if db.Lorti then
            border:SetAllPoints(rp)
        else
            if isTempEnchant then
                border:SetPoint("TOPLEFT", rp, "TOPLEFT", 0, 0)
                border:SetPoint("BOTTOMRIGHT", rp, "BOTTOMRIGHT", 0, 0)
                if db.modtheme then
                    border:SetVertexColor(1, 0, 1)
                elseif db.Modern then
                    border:SetVertexColor(0.7, 0.3, 1)
                end
            else
                border:SetPoint("TOPLEFT", rp, "TOPLEFT", -1, 1)
                border:SetPoint("BOTTOMRIGHT", rp, "BOTTOMRIGHT", 1, -1)
            end
        end
        button.border = border
    end

    -- Lortis shadowy BG
    if (db.Lorti or db.Roug) then
        if db.Roug and isDebuff then
            return
        end
        local bg = CreateFrame("Frame", nil, button, BackdropTemplateMixin and "BackdropTemplate")
        local yOffset = (db.Roug and button.Symbol) and -3 or 4
        bg:SetPoint("TOPLEFT", rp, "TOPLEFT", -4, 4)
        bg:SetPoint("BOTTOMRIGHT", rp, "BOTTOMRIGHT", 4, -4)
        bg:SetFrameLevel(math.max(button:GetFrameLevel() - 1, 0))
        bg:SetBackdrop(backdrop)
        bg:SetBackdropBorderColor(0.05, 0.05, 0.05)
        button.bg = bg
    end
end
RougeUI.addBorder = addBorder

local function BtnGlow(button)
    local border = button.border
    local debuff

    if button.auraType == "Debuff" then
        debuff = true
    else
        return
    end

    if not button.bg and debuff then
        button.bg = CreateFrame("Frame", nil, button, BackdropTemplateMixin and "BackdropTemplate")
        button.bg:SetPoint("TOPLEFT", button.Icon, "TOPLEFT", -5, 5)
        button.bg:SetPoint("BOTTOMRIGHT", button.Icon, "BOTTOMRIGHT", 5, -5)
        button.bg:SetFrameLevel(button:GetFrameLevel() - 1)
        button.bg:SetBackdrop(backdrop)
    end

    if debuff and button.bg then
        local r, g, b, a = border:GetVertexColor()
        button.bg:SetBackdropBorderColor(r, g, b, 1)
    end
end

local function TimeFormat(button)
    local time = button.timeLeft
    local duration = button.Duration
    local h, m, s, text

    if not duration or not time then
        return
    end

    if RougeUI.db.OmniCC then
        if duration and duration:GetAlpha() > 0 then
            local buffType = button.auraType
            if buffType == "Buff" or buffType == "Debuff" or buffType == "TempEnchant" then
                duration:SetAlpha(0)
            end
        end

        if button and not button.cooldown then
            local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
            cooldown:SetAllPoints(button.Icon)
            cooldown:SetFrameLevel(button:GetFrameLevel())
            cooldown:SetReverse(true)
            button.cooldown = cooldown
        end

        if button.cooldown and (not button.cooldownSet or time >= button.cooldownSet) then
            CooldownFrame_Set(button.cooldown, GetTime(), time, true)
            button.cooldownSet = time
        end
        return
    end

    if time <= 0 then
        text = ""
    elseif time >= 86400 then
        local d = floor(time / 86400 + 0.99)
        if RougeUI.db.modtheme then
            text = duration:SetFormattedText("|cffffffff%d|rd", d)
        else
            text = duration:SetFormattedText("|r%d|rd", d)
        end
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

    local buffFrame, debuffFrame
    local icon = bu.Icon

    if bu.auraType == "Buff" then
        buffFrame = true
    elseif bu.auraType == "Debuff" then
        debuffFrame = true
    end

    if icon then
        if debuffFrame and not RougeUI.db.Lorti then
            icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
            if RougeUI.db.modtheme then
                icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, 1)
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
                icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 9)
            else
                icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
            end
        end
    end

    bu:ClearNormalTexture()

    if RougeUI.db.Lorti then
        bu:SetSize(28, 28)
        bu.Icon:SetSize(28, 28)
        bu.Duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        bu.Duration:ClearAllPoints()
        bu.Duration:SetPoint("BOTTOM", bu.Icon, 1, 0)
    else
        bu.Duration:SetFont(STANDARD_TEXT_FONT, 9.5, "OUTLINE")
        bu.Duration:SetShadowOffset(0, 0)
        local point, relativeTo, relativePoint, xOfs, yOfs = bu.Duration:GetPoint()
        local yOffset, xOffset
        local parent = bu:GetParent()
        if not parent.isHorizontal then
            yOffset = yOfs
            xOffset = parent.addIconsToRight and 7 or -5
        else
            yOffset = parent.addIconsToTop and 7 or -5
            xOffset = xOfs
        end
        bu.Duration:ClearAllPoints()
        bu.Duration:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
    end

    if not bu.hookedDuration and debuffFrame and bu.Duration then
        bu.hookedDuration = true
        if RougeUI.db.Lorti then
            hooksecurefunc(bu.Duration, "SetPoint", function(self)
                if self.moved then
                    return
                end
                self.moved = true
                local _, rt = self:GetPoint()
                self:ClearAllPoints()
                self:SetPoint("TOP", rt, "BOTTOM", 0, 11)
                self.moved = false
            end)
        else
            hooksecurefunc(bu.Duration, "SetPoint", function(self)
                if self.moved then
                    return
                end
                self.moved = true
                local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
                local yOffset, xOffset
                local parent = self:GetParent()
                local grandparent = parent and parent:GetParent()
                if grandparent and not grandparent.isHorizontal then
                    yOffset = yOfs
                    xOffset = (grandparent and grandparent.addIconsToRight) and 7 or -5
                else
                    yOffset = (grandparent and grandparent.addIconsToTop) and 7 or -5
                    xOffset = xOfs
                end
                self:ClearAllPoints()
                self:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
                self.moved = false
            end)
        end
    end

    if bu.Count and not RougeUI.db.modtheme then
        bu.Count:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
        bu.Count:SetShadowOffset(0, 0)
        bu.Count:ClearAllPoints()
        bu.Count:SetPoint("TOPRIGHT", bu.Icon, 1, 0)
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

    if bu.SlotBackground then
        bu.SlotBackground:SetAlpha(0)
    end

    addBorder(bu, "BACKGROUND")

    bu.styled = true
end

local function skinBags(button)
    if not button or button.styled then
        return
    end

    local icon = _G[button:GetName() .. "IconTexture"]
    local nt = _G[button:GetName() .. "NormalTexture"]

    nt:SetTexCoord(0, 1, 0, 1)
    nt:SetDrawLayer("BACKGROUND", -7)
    nt:SetVertexColor(0.4, 0.35, 0.35)
    nt:SetAllPoints(button)
    local bo = button.IconBorder
    bo:SetAlpha(0)
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

    addBorder(button, "BACKGROUND")
    button.styled = true
end

local function OmniTimers(buttonName, index, filter)
    if not index then
        return
    end

    local aura = C_UnitAuras.GetAuraDataByIndex("player", index, filter)
    if not aura then
        return
    end

    if buttonName and not buttonName.cooldown then
        local cooldown = CreateFrame("Cooldown", nil, buttonName, "CooldownFrameTemplate")
        cooldown:SetAllPoints(buttonName.Icon)
        cooldown:SetFrameLevel(buttonName:GetFrameLevel())
        cooldown:SetReverse(true)
        buttonName.cooldown = cooldown
    end

    if buttonName and buttonName.cooldown and aura.duration then
        CooldownFrame_Set(buttonName.cooldown, aura.expirationTime - aura.duration, aura.duration, true)
    end
end

local function init()
    -- Actionbars
    if not IsAddOnLoaded("Masque") then
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
            for i = 1, 168 do
                local btn = _G["DominosActionButton" .. i]
                if btn then
                    styleActionButton(btn)
                end
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

    if PlayerCastingBarFrame.Icon and RougeUI.db.CastTimer then
        local cf = CreateFrame("Frame", nil, PlayerCastingBarFrame, BackdropTemplateMixin and "BackdropTemplate")
        addBorder(cf, "OVERLAY")
        cf:SetAllPoints(PlayerCastingBarFrame.Icon)
        PlayerCastingBarFrame.Icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
        local zz = (RougeUI.db.Lorti and 23) or (RougeUI.db.modtheme and 25) or 24
        PlayerCastingBarFrame.Icon:SetSize(zz, zz)
    end

    for i = 0, 3 do
        skinBags(_G["CharacterBag" .. i .. "Slot"])
    end
    skinBags(MainMenuBarBackpackButton)
end

local function HookAuras()
    if not bartender4 and not IsAddOnLoaded("Masque") then
        for _, btn in pairs(ActionBarButtonEventsFrame.frames) do
            if RougeUI.db.Lorti then
                hooksecurefunc(btn, "Update", function(self)
                    local action = self.action
                    local border = self.Border
                    if border then
                        if IsEquippedAction(action) then
                            border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss_grey")
                            border:SetSize(36, 36)
                            border:SetVertexColor(0.499, 0.999, 0.499, 1)
                            border:SetAlpha(1)
                        else
                            if border:GetAlpha() > 0 then
                                border:SetAlpha(0)
                            end
                        end
                    end
                end)
            end
            hooksecurefunc(btn, "UpdateHotkeys", function(self)
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
end

local function shorten(val)
    if val >= 1e3 then
        return string.format("%dk", floor((val / 1e3) + 0.5))
    else
        return tostring(val)
    end
end

local e3 = CreateFrame("Frame")
e3:RegisterEvent("PLAYER_LOGIN")
e3:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        local skinEnabled = RougeUI.db.Lorti or RougeUI.db.Roug or RougeUI.db.Modern or RougeUI.db.modtheme
        if skinEnabled or RougeUI.db.TimerGap or RougeUI.db.OmniCC then
            if RougeUI.db.OmniCC or not (IsAddOnLoaded("SeriousBuffTimers") or IsAddOnLoaded("BuffTimers")) then
                for _, buffs in ipairs(BuffFrame.auraFrames) do
                    if buffs.SetFormattedText then
                        hooksecurefunc(buffs, "UpdateDuration", TimeFormat)
                    end
                end

                for _, debuffs in ipairs(DebuffFrame.auraFrames) do
                    if debuffs.SetFormattedText then
                        hooksecurefunc(debuffs, "UpdateDuration", TimeFormat)
                    end
                end
            end

            if skinEnabled then
                init()
                HookAuras()
            end

            if skinEnabled or RougeUI.db.OmniCC then
                for index, aura in ipairs({ BuffFrame.AuraContainer:GetChildren() }) do
                    if aura and aura.Icon then
                        hooksecurefunc(aura, "Update", function(self)
                            if not self.styled and skinEnabled then
                                SkinBuffs(self)
                            end

                            if RougeUI.db.OmniCC then
                                OmniTimers(self, self.buttonInfo.index, "HELPFUL")
                            end
                        end)
                    end
                end

                for index, aura in ipairs({ DebuffFrame.AuraContainer:GetChildren() }) do
                    if aura and aura.Icon then
                        hooksecurefunc(aura, "Update", function(self)
                            if not self.styled and skinEnabled then
                                SkinBuffs(self)
                            end
                            if self and RougeUI.db.Roug then
                                BtnGlow(self)
                            end

                            if RougeUI.db.OmniCC then
                                OmniTimers(self, self.buttonInfo.index, "HARMFUL")
                            end
                        end)
                    end
                end
            end

        end
        --elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        --    local _, event, _, sourceGUID, _, _, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo()
        --
        --    if (event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED") and spellId == 76577 then
        --        if RougeUI.bombExpireTime == nil then
        --            RougeUI.bombExpireTime = {}
        --        end
        --
        --        local now = GetTime()
        --        if (RougeUI.bombExpireTime[sourceGUID] and now >= RougeUI.bombExpireTime[sourceGUID]) or event == "SPELL_CAST_SUCCESS" then
        --            RougeUI.bombExpireTime[sourceGUID] = now + 6
        --        elseif not RougeUI.bombExpireTime[sourceGUID] then
        --            RougeUI.bombExpireTime[sourceGUID] = now + 6
        --        end
        --    end
    elseif event == "PLAYER_ENTERING_WORLD" then
        RougeUI.bombExpireTime = {}
    end
end)
