local _, RougeUI = ...
local _G = getfenv(0)
local IsAddOnLoaded = _G.IsAddOnLoaded
local bartender = IsAddOnLoaded("Bartender4")
local dominos = IsAddOnLoaded("Dominos")
local GetBindingKey, SetOverrideBindingClick = _G.GetBindingKey, _G.SetOverrideBindingClick
local InCombatLockdown = _G.InCombatLockdown
local SecureHandlerUnwrapScript = _G.SecureHandlerUnwrapScript
local tonumber = _G.tonumber
local frame = CreateFrame("Frame")

local function WAHK(button)
    if not button then
        return
    end

    local clickButton
    local btn = _G[button]

    if button:match("BT4Button") then
        clickButton = ("CLICK %s:LeftButton"):format(button)
    elseif button:match("DominosActionButton") then
        clickButton = ("CLICK %s:HOTKEY"):format(button)
    else
        local id = tonumber(button:match("(%d+)"))
        local actionButtonType = btn.buttonType
        local buttonType = actionButtonType and (actionButtonType .. id) or ("ACTIONBUTTON%d"):format(id)
        clickButton = buttonType or ("CLICK " .. button .. ":LeftButton")
    end

    local key = GetBindingKey(clickButton)

    if btn then
        btn:RegisterForClicks("AnyDown", "AnyUp")
        if dominos then
            SecureHandlerUnwrapScript(btn, "OnClick")
        end
    end

    if key and not bartender then
        SetOverrideBindingClick(btn, true, key, btn:GetName())
    end
end

local function UpdateBinds()
    if InCombatLockdown() then
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    if OverrideActionBar and OverrideActionBar:IsShown() then
        for i = 1, 6 do
            local ob = _G["ActionButton" .. i];
            ClearOverrideBindings(ob)
        end
        return
    end

    for i = 1, 12 do
        WAHK("ActionButton" .. i)
        WAHK("MultiBarBottomRightButton" .. i)
        WAHK("MultiBarBottomLeftButton" .. i)
        WAHK("MultiBarRightButton" .. i)
        WAHK("MultiBarLeftButton" .. i)
    end

    if bartender or dominos then
        for i = 1, 180 do
            if bartender then
                WAHK("BT4Button" .. i)
            else
                WAHK("DominosActionButton" .. i)
            end
        end
    end
end

frame:RegisterEvent("UPDATE_BINDINGS")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
frame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
frame:SetScript("OnEvent", function(self, event, ...)
    if not RougeUI.db.KeyEcho then
        -- stop copying my work, use the addon.
        self:UnregisterAllEvents()
        self:SetScript("OnEvent", nil)
        return
    end
    if event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
    C_Timer.After(1, UpdateBinds)
end)