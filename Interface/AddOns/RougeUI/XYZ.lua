local _, RougeUI = ...
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
local bartender = IsAddOnLoaded("Bartender4")
local dominos = IsAddOnLoaded("Dominos")
local frame = CreateFrame("Frame")
local wahkFrames = {}

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
        if string.match(name, "Dominos") then
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

    local key, key2 = GetBindingKey(clickButton)
    if not key and not key2 then
        return
    end

    local cacheKeys = {}
    if key then
        cacheKeys[key] = key
    end
    if key2 then
        cacheKeys[key2] = key2
    end

    for v in pairs(cacheKeys) do
        local action = GetBindingAction(v, true)
        if action and action ~= "" then
            btn = _G[ConvertActionButtonName(action)]
        end

        if btn then
            local btnName = btn:GetName()
            local clk = tostring(btnName)

            if not id then
                id = tonumber(button:match("(%d+)"))
            end

            local wahkName = "WAHK" .. v .. button
            local wahk = _G[wahkName] or CreateFrame("Button", wahkName, nil, "SecureActionButtonTemplate")
            wahkFrames[wahkName] = true

            wahk:RegisterForClicks("AnyDown", "AnyUp")
            wahk:SetAttribute("type", "click")
            wahk:SetAttribute("clickbutton", _G[button])

            SetOverrideBindingClick(wahk, true, v, wahk:GetName())

            wahk:SetScript("OnMouseDown", function()
                if OverrideActionBar and OverrideActionBar:IsShown() and id then
                    local obtn = _G["OverrideActionBarButton" .. id]
                    if obtn then
                        obtn:SetButtonState("PUSHED")
                        if RougeUI.db.ButtonAnim then
                            RougeUI.Animate(obtn)
                        end
                    end
                else
                    if btn then
                        btn:SetButtonState("PUSHED")
                        if RougeUI.db.ButtonAnim then
                            RougeUI.Animate(btn)
                        end
                    end
                end
            end)
            wahk:SetScript("OnMouseUp", function()
                if OverrideActionBar and OverrideActionBar:IsShown() and id then
                    local obtn = _G["OverrideActionBarButton" .. id]
                    if obtn then
                        obtn:SetButtonState("NORMAL")
                        if RougeUI.db.wahksfk then
                            RougeUI.Animate(obtn)
                        end
                    end
                else
                    if btn then
                        btn:SetButtonState("NORMAL")
                        if RougeUI.db.wahksfk then
                            RougeUI.Animate(btn)
                        end
                    end
                end
            end)
        end
    end
end

local function UpdateBinds()
    if InCombatLockdown() then
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    for name in pairs(wahkFrames) do
        local wahk = _G[name]
        if wahk then
            ClearOverrideBindings(wahk)
            SecureHandlerUnwrapScript(wahk, "OnClick")
        end
    end
    wipe(wahkFrames)

    for i = 1, 12 do
        WAHK("ActionButton" .. i, true)
        WAHK("MultiBarBottomRightButton" .. i)
        WAHK("MultiBarBottomLeftButton" .. i)
        WAHK("MultiBarRightButton" .. i)
        WAHK("MultiBarLeftButton" .. i)
    end

    if bartender or dominos then
        for i = 1, 180 do
            local btnName = bartender and "BT4Button" or "DominosActionButton"
            WAHK(btnName .. i)
        end
    end
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" and RougeUI.db.KeyEcho then
        self:RegisterEvent("UPDATE_BINDINGS")
        C_Timer.After(1, UpdateBinds)
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        C_Timer.After(1, UpdateBinds)
    elseif event == "UPDATE_BINDINGS" then
        C_Timer.After(1, UpdateBinds)
    end
end)
