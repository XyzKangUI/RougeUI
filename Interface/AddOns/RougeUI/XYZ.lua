local _, RougeUI = ...
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
local bartender = IsAddOnLoaded("Bartender4")
local dominos = IsAddOnLoaded("Dominos")
local tonumber, strmatch = tonumber, string.match
local frame = CreateFrame("Frame")

local buttonNames = {
    ["ACTIONBUTTON"] = "ActionButton",
    ["MULTIACTIONBAR1BUTTON"] = "MultiBarBottomLeftButton",
    ["MULTIACTIONBAR2BUTTON"] = "MultiBarBottomRightButton",
    ["MULTIACTIONBAR3BUTTON"] = "MultiBarRightButton",
    ["MULTIACTIONBAR4BUTTON"] = "MultiBarLeftButton",
    ["CLICK BT4Button"] = "BT4Button",
    ["CLICK DominosActionButton"] = "DominosActionButton",
}

local function ConvertActionButtonName(name)
    -- remove "CLICK "
    name = name:gsub("^CLICK ", "")

    -- remove ":Keybind"
    name = name:gsub(":Keybind$", "")

    if dominos then
        if strmatch(name, "Dominos") then
            name = name:gsub(":LeftButton", "")
            name = name:gsub(":HOTKEY", "")
        end
    end

    local button, buttonNumber = name:match("^(.-)(%d+)$")
    if button and tonumber(buttonNumber) and buttonNames[button] then
        name = buttonNames[button] .. buttonNumber
    end

    return name
end

local function WAHK(button, ok)
    if not button then
        return
    end

    local btn = _G[button]
    if not btn then
        return
    end

    local clickButton, id
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
    if not key then
        return
    end

    local action = GetBindingAction(key, true)

    if action and (action ~= "") then
        btn = _G[ConvertActionButtonName(action)]
    end

    if btn then
        local btnName = btn:GetName()
        local clk = tostring(btnName)

        if not id then
            id = tonumber(button:match("(%d+)"))
        end

        local wahk = CreateFrame("Button", "WAHK" .. button, nil, "SecureActionButtonTemplate")
        wahk:RegisterForClicks("AnyDown", "AnyUp")
        wahk:SetAttribute("type", "macro")

        local onclick
        if ok then
            onclick = string.format([[ local id = tonumber(self:GetName():match("(%d+)")) if down then self:SetAttribute("macrotext", "/click [vehicleui] OverrideActionBarButton" .. id .. "; ActionButton" .. id) else self:SetAttribute("macrotext", "/click [vehicleui] OverrideActionBarButton" .. id .. "; ActionButton" .. id) end]], id, id, id)
        else
            onclick = ([[ if down then self:SetAttribute("macrotext", "/click clk") else self:SetAttribute("macrotext", "/click clk") end]]):gsub("clk", clk), nil
        end

        ClearOverrideBindings(wahk)
        SecureHandlerWrapScript(wahk, "OnClick", wahk, onclick)
        SetOverrideBindingClick(wahk, true, key, wahk:GetName())

        wahk:SetScript("OnMouseDown", function() if OverrideActionBar and OverrideActionBar:IsShown() and id then local obtn = _G["OverrideActionBarButton" .. id] obtn:SetButtonState("PUSHED") if RougeUI.db.ButtonAnim then RougeUI.Animate(obtn) end else btn:SetButtonState("PUSHED") if RougeUI.db.ButtonAnim then RougeUI.Animate(btn) end end end)
        wahk:SetScript("OnMouseUp", function() if OverrideActionBar and OverrideActionBar:IsShown() and id then _G["OverrideActionBarButton" .. id]:SetButtonState("NORMAL") else btn:SetButtonState("NORMAL") end end)
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
        -- stop copying, use the addon.
        self:UnregisterAllEvents()
        self:SetScript("OnEvent", nil)
        return
    end

    if event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end

    C_Timer.After(1, UpdateBinds)
end)