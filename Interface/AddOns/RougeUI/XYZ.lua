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

local function WAHK(button, ok)
    if not button then
        return
    end

    local btn = _G[button]
    if not btn then
        return
    end

    local clickButton, id
    local clk = tostring(button)
    if button:match("BT4Button") then
        clickButton = ("CLICK %s:LeftButton"):format(button)
    elseif button:match("DominosActionButton") then
        clickButton = ("CLICK %s:HOTKEY"):format(button)
    else
        id = tonumber(button:match("(%d+)"))
        local actionButtonType = btn.buttonType
        local buttonType = actionButtonType and (actionButtonType .. id) or ("ACTIONBUTTON%d"):format(id)
        clickButton = buttonType or ("CLICK " .. button .. ":LeftButton")
    end

    local key = GetBindingKey(clickButton)

    if btn and dominos then
        SecureHandlerUnwrapScript(btn, "OnClick")
    end

    if key and btn then
        if ok then
            local wahk = CreateFrame("Button", "WAHK" .. button, nil, "SecureActionButtonTemplate")
            wahk:RegisterForClicks("AnyDown", "AnyUp")
            wahk:SetAttribute("type", "macro")
            local onclick = string.format([[ local id = tonumber(self:GetName():match("(%d+)")) if down then if HasVehicleActionBar() then self:SetAttribute("macrotext", "/click OverrideActionBarButton" .. id) else self:SetAttribute("macrotext", "/click ActionButton" .. id) end else if HasVehicleActionBar() then self:SetAttribute("macrotext", "/click OverrideActionBarButton" .. id) else self:SetAttribute("macrotext", "/click ActionButton" .. id) end end]], id, id, id)
            SecureHandlerWrapScript(wahk, "OnClick", wahk, onclick)
            SetOverrideBindingClick(wahk, true, key, wahk:GetName())
            wahk:SetScript("OnMouseDown", function() if HasVehicleActionBar() then _G["OverrideActionBarButton"..id]:SetButtonState("PUSHED") else btn:SetButtonState("PUSHED") end end)
            wahk:SetScript("OnMouseUp", function() if HasVehicleActionBar() then _G["OverrideActionBarButton"..id]:SetButtonState("NORMAL") else btn:SetButtonState("NORMAL") end end)
        else
            btn:RegisterForClicks("AnyDown", "AnyUp")
            local onclick = ([[ if down then
        self:SetAttribute("macrotext", "/click clk") else self:SetAttribute("macrotext", "/click clk") end
    ]]):gsub("clk", clk), nil
            SecureHandlerWrapScript(btn, "OnClick", btn, onclick)
            if not bartender then
                SetOverrideBindingClick(btn, true, key, btn:GetName())
            end
        end
    end
end

local function UpdateBinds()
    if InCombatLockdown() then
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    for i = 1, 12 do
        WAHK("ActionButton" .. i, true)
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