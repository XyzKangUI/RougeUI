local _, RougeUI = ...
local wahkHeader = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local binderFrame = CreateFrame("Frame")
local wahkButtons = {}
local boundKeys = {}
local bartender = C_AddOns.IsAddOnLoaded("Bartender4")
local pendingUpdate

local defaultButtons = {
    ACTIONBUTTON = "ActionButton",
    MULTIACTIONBAR1BUTTON = "MultiBarBottomLeftButton",
    MULTIACTIONBAR2BUTTON = "MultiBarBottomRightButton",
    MULTIACTIONBAR3BUTTON = "MultiBarRightButton",
    MULTIACTIONBAR4BUTTON = "MultiBarLeftButton",
    MULTIACTIONBAR5BUTTON = "MultiBar5Button",
    MULTIACTIONBAR6BUTTON = "MultiBar6Button",
    MULTIACTIONBAR7BUTTON = "MultiBar7Button",
}

local function GetAllBindings()
    local realBtn = {}
    local cachedKey = {}

    for i = 1, GetNumBindings() do
        local _, _, key1, key2 = GetBinding(i)

        if key1 and not cachedKey[key1] then
            cachedKey[key1] = true
            local command = C_KeyBindings.GetBindingByKey(key1)

            if command then
                local btnName = command

                if command:match("^CLICK") then
                    btnName = command:match("CLICK (.-):") or command:match("CLICK (.-)$")
                end

                if btnName then
                    local cleanBtn = btnName:match("^(.*%d)")

                    if cleanBtn then
                        local base, id = cleanBtn:match("^(.-)(%d+)$")
                        if base and id then
                            local blizzBtn = defaultButtons[base:upper()]
                            if blizzBtn then
                                cleanBtn = blizzBtn .. id
                            end
                        end

                        realBtn[cleanBtn] = realBtn[cleanBtn] or {}
                        table.insert(realBtn[cleanBtn], key1)
                    end
                end
            end
        end

        if key2 and not cachedKey[key2] then
            cachedKey[key2] = true
            local command = C_KeyBindings.GetBindingByKey(key2)

            if command then
                local btnName = command
                
                if command:match("^CLICK") then
                    btnName = command:match("CLICK (.-):") or command:match("CLICK (.-)$")
                end

                if btnName then
                    local cleanBtn = btnName:match("^(.*%d)")

                    if cleanBtn then
                        local base, id = cleanBtn:match("^(.-)(%d+)$")
                        if base and id then
                            local blizzBtn = defaultButtons[base:upper()]
                            if blizzBtn then
                                cleanBtn = blizzBtn .. id
                            end
                        end

                        realBtn[cleanBtn] = realBtn[cleanBtn] or {}
                        table.insert(realBtn[cleanBtn], key2)
                    end
                end
            end
        end
    end

    return realBtn
end

local function addWAHK(buttonName, btn)
    local wahkBtn = wahkButtons[buttonName]
    if wahkBtn then
        return wahkBtn
    end

    wahkBtn = CreateFrame("Button", "WAHK_" .. buttonName, nil, "SecureActionButtonTemplate")

    if bartender then
        btn:SetAttribute("pressAndHoldAction", true)
        btn:SetAttribute("typerelease", btn._state_type)

        if not btn.wahkHook then
            btn.wahkHook = true
            local attributeChange = [[
                if name == "pressandholdaction" then
                    if self:GetAttribute("pressAndHoldAction") ~= true then
                        self:SetAttribute("pressAndHoldAction", true)
                        local type = self:GetAttribute("type") or "action"
                        self:SetAttribute("typerelease", type)
                    end
                end
            ]]
            SecureHandlerWrapScript(btn, "OnAttributeChanged", wahkHeader, attributeChange)
        end
    end

    wahkBtn:RegisterForClicks("AnyDown", "AnyUp")
    wahkBtn:SetAttribute("type", "click")
    wahkBtn:SetAttribute("typerelease", "click")
    wahkBtn:SetAttribute("pressAndHoldAction", true)
    wahkBtn:SetAttribute("clickbutton", btn)

    wahkBtn:SetScript("OnMouseDown", function()
        if btn:IsVisible() then
            btn:SetButtonState("PUSHED")
            if RougeUI.db.ButtonAnim then
                RougeUI.Animate(btn)
            end
        end
    end)

    wahkBtn:SetScript("OnMouseUp", function()
        if btn:IsVisible() then
            btn:SetButtonState("NORMAL")
            if RougeUI.db.ButtonAnim and RougeUI.db.wahksfk then
                RougeUI.Animate(btn)
            end
        end
    end)

    wahkButtons[buttonName] = wahkBtn
    return wahkBtn
end

local function WAHK(buttonName, keys)
    local btn = _G[buttonName]
    if not btn or not keys then
        return
    end

    local wahk = addWAHK(buttonName, btn)

    for _, key in ipairs(keys) do
        if not boundKeys[key] then
            SetOverrideBindingClick(binderFrame, true, key, wahk:GetName(), "LeftButton")
            boundKeys[key] = true
        end
    end
end

local function updateBinds()
    if InCombatLockdown() then
        wahkHeader:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    ClearOverrideBindings(binderFrame)
    wipe(boundKeys)

    local binds = GetAllBindings()
    for btn, key in pairs(binds) do
        WAHK(btn, key)
    end
end

local function scheduledUpdate()
    if pendingUpdate then
        return
    end
    pendingUpdate = true
    C_Timer.After(0.5, function()
        pendingUpdate = nil
        updateBinds()
    end)
end

wahkHeader:RegisterEvent("PLAYER_LOGIN")
wahkHeader:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" and RougeUI.db.KeyEcho then
        self:RegisterEvent("UPDATE_BINDINGS")
        scheduledUpdate()
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        scheduledUpdate()
    elseif event == "UPDATE_BINDINGS" then
        scheduledUpdate()
    end
end)