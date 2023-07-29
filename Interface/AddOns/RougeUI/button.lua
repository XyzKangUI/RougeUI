local _, RougeUI = ...
local IsAddOnLoaded, hooksecurefunc = IsAddOnLoaded, hooksecurefunc
local _G = getfenv(0)
local ceil, mod = _G.math.ceil, _G.math.fmod
local dominos = IsAddOnLoaded("Dominos")
local bartender4 = IsAddOnLoaded("Bartender4")

if (IsAddOnLoaded("Masque") and (dominos or bartender4)) then
    return
end

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
        border = button:CreateTexture(nil, drawLayer or "BACKGROUND", nil, -7)
    end

    if button and border then
        if RougeUI.db.Lorti then
            if button.debuff and dbf then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss2")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss")
            end
        elseif RougeUI.db.Roug then
            if button.debuff then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\debuff")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\rouge")
            end
        elseif RougeUI.db.Modern then
            if button.debuff then
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\expdebuff")
            else
                border:SetTexture("Interface\\AddOns\\RougeUI\\textures\\art\\exp")
            end
        end

        border:SetTexCoord(0, 1, 0, 1)
        border:SetDrawLayer(drawLayer or "BACKGROUND", -7)
        if not button.debuff then
            border:SetVertexColor(RougeUI.db.BuffVal, RougeUI.db.BuffVal, RougeUI.db.BuffVal)
        elseif button.tempenchant then
            border:SetVertexColor(.7, 0, 1)
        end
        border:ClearAllPoints()
        if RougeUI.db.Lorti then
            border:SetAllPoints(button)
        else
            if button.tempenchant then
                border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
                border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
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
        if RougeUI.db.Roug then
            bg:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
            bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)
        else
            bg:SetPoint("TOPLEFT", button, "TOPLEFT", -5, 5)
            bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 5, -5)
        end
        bg:SetFrameLevel(button:GetFrameLevel() - 1)
        bg:SetBackdrop(backdrop)
        bg:SetBackdropBorderColor(0.05, 0.05, 0.05)
        button.bg = bg
    end
end

local function BtnGlow(button)
    local bg
    local name = button:GetName()
    local border = _G[name .. "Border"]

    if name:match("Debuff") then
        button.debuff = true
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

local function SkinBuffs(bu)
    if not bu or (bu and bu.styled) then
        return
    end

    local name = bu:GetName()
    local icon = _G[name .. "Icon"]

    if icon then
        if name:match("Debuff") and not RougeUI.db.Lorti then
            icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
        else
            if RougeUI.db.Lorti then
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
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
        bu.duration:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
        bu.duration:ClearAllPoints()
        bu.duration:SetPoint("BOTTOM", 1, 0)
    else
        bu.duration:ClearAllPoints()
        bu.duration:SetPoint("CENTER", bu, "BOTTOM", 0, -6.5)
        if RougeUI.db.Roug or RougeUI.db.Modern then
            bu.duration:SetFont(STANDARD_TEXT_FONT, 9.5, "THINOUTLINE")
            bu.duration:SetShadowOffset(0, 0)
        end
    end

    if bu.count then
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
    local ho = _G[name .. "HotKey"]
    local fbg = _G[name .. "FloatingBG"]
    local fob = _G[name .. "FlyoutBorder"]
    local fobs = _G[name .. "FlyoutBorderShadow"]
    local ic = _G[name .. "Icon"]
    local nt = _G[name .. "NormalTexture"]
    local nt2 = _G[name .. "NormalTexture2"]

    if nt then
        nt:SetTexture(nil)
    end
    if nt2 then
        nt2:SetTexture(nil)
    end

    if ic then
        if RougeUI.db.Lorti then
            ic:SetTexCoord(0, 1, 0, 1)
        else
            ic:SetTexCoord(0.06, 0.94, 0.06, 0.94)
        end
    end

    if not bartender4 then
        if RougeUI.db.Lorti then
            ho:ClearAllPoints()
            ho:SetPoint("TOPRIGHT", bu, -1, -3)
            ho:SetPoint("TOPLEFT", bu, -1, -3)
        else
            ho:ClearAllPoints()
            ho:SetPoint("TOPRIGHT", bu, 1, -2)
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

    if RougeUI.db.Lorti then
        bu:SetPushedTexture("Interface\\AddOns\\RougeUI\\textures\\art\\pushed")
        bu:SetNormalTexture("Interface\\AddOns\\RougeUI\\textures\\art\\gloss")
        if not nt then
            nt = bu:GetNormalTexture()
        end
        if not nt2 then
            nt2 = bu:GetNormalTexture()
        end
        if nt then
            nt:SetAllPoints(bu)
        end
        if nt2 then
            nt2:SetAllPoints(bu)
        end
        local bg = CreateFrame("Frame", nil, bu, BackdropTemplateMixin and "BackdropTemplate")
        bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -4, 4)
        bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 4, -4)
        bg:SetFrameLevel(bu:GetFrameLevel() - 1)
        bg:SetBackdrop(backdrop)
        bg:SetBackdropBorderColor(0.05, 0.05, 0.05)
        bu.bg = bg
    else
        addBorder(bu, "OVERLAY")
    end

    bu.styled = true
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
    addBorder(tf,"OVERLAY")
    tf:SetAllPoints(TargetFrameSpellBar.Icon)
    TargetFrameSpellBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    local ff = CreateFrame("Frame", nil, FocusFrameSpellBar, BackdropTemplateMixin and "BackdropTemplate")
    addBorder(ff, "OVERLAY")
    ff:SetAllPoints(FocusFrameSpellBar.Icon)
    FocusFrameSpellBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    -- TempEnchantFrame
    for i = 1, NUM_TEMP_ENCHANT_FRAMES do
        local bu = _G["TempEnchant" .. i]
        if (bu and not bu.styled) then
            SkinBuffs(bu)
        end
    end
end

local function HookAuras()
    hooksecurefunc("TargetFrame_UpdateAuras", function()
        for i = 1, 32 do
            local bu = _G["TargetFrameBuff" .. i]
            if bu then
                if not bu.skin then
                    addBorder(bu)
                    _G["TargetFrameBuff" .. i .. "Icon"]:SetTexCoord(.1, .9, .1, .9)
                    bu.skin = true
                end
            else
                break
            end
        end
        for i = 1, 16 do
            local bu = _G["TargetFrameDebuff" .. i]
            if bu then
                if not bu.skin then
                    addBorder(bu)
                    _G["TargetFrameDebuff" .. i .. "Icon"]:SetTexCoord(.1, .9, .1, .9)
                    bu.skin = true
                end
            else
                break
            end
        end
        for i = 1, 32 do
            local bu = _G["FocusFrameBuff" .. i]
            if bu then
                if not bu.skin then
                    addBorder(bu)
                    _G["FocusFrameBuff" .. i .. "Icon"]:SetTexCoord(.1, .9, .1, .9)
                    bu.skin = true
                end
            else
                break
            end
        end
        for i = 1, 16 do
            local bu = _G["FocusFrameDebuff" .. i]
            if bu then
                if not bu.skin then
                    addBorder(bu)
                    _G["FocusFrameDebuff" .. i .. "Icon"]:SetTexCoord(.1, .9, .1, .9)
                    bu.skin = true
                end
            else
                break
            end
        end
    end)
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
        if not IsAddOnLoaded("SimpleAuraFilter") then
            hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", BuffAnchor)
            hooksecurefunc("DebuffButton_UpdateAnchors", DebuffAnchor)
        end

        if RougeUI.db.Lorti or RougeUI.db.Roug or RougeUI.db.Modern then
            init()
            hooksecurefunc("AuraButton_Update", function(self, index)
                local button = _G[self .. index]
                if button and not button.styled then
                    SkinBuffs(button)
                end
                if button and RougeUI.db.Roug then
                    BtnGlow(button)
                end
            end)
            hooksecurefunc("ActionButton_ShowGrid", function(btn)
                if btn then
                    _G[btn:GetName() .. "NormalTexture"]:SetVertexColor(1, 1, 1, 1)
                end
            end)
            HookAuras()
        end
        self:UnregisterEvent("PLAYER_LOGIN")
        self:SetScript("OnEvent", nil)
    end
end)
