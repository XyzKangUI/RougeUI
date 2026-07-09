local _, RougeUI = ...
local wahkHeader = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local wahkButtons = {}
local boundKeys = {}
local bartender = C_AddOns.IsAddOnLoaded("Bartender4")
local pendingUpdate
local binderFrame = CreateFrame("Frame", nil, nil, "SecureHandlerStateTemplate")

local SECURE_APPLY_BINDINGS = [[
	local state = self:GetAttribute("wahk_override_state") or "normal"
	local useOverride = state == "override"
	local count = self:GetAttribute("wahk_count") or 0

	self:ClearBindings()

	for i = 1, count do
		local key = self:GetAttribute("wahk_key" .. i)
		local normal = self:GetAttribute("wahk_normal" .. i)
		local override = self:GetAttribute("wahk_override" .. i)

		if override == "" then
			override = nil
		end

		local btn = normal

		if useOverride and override then
			btn = override
		end

		if key and btn then
			self:SetBindingClick(true, key, btn, "LeftButton")
		end
	end
]]

local SECURE_ONSTATE_OVERRIDEBUTTON = [[
	self:SetAttribute("wahk_override_state", newstate)
]] .. SECURE_APPLY_BINDINGS


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

local function addWAHK(buttonName, btn, isOverride)
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
    if not isOverride then
        wahkBtn:SetAttribute("typerelease", "click")
        wahkBtn:SetAttribute("pressAndHoldAction", true)
    end
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
    
    wahkBtn:SetScript("PostClick", function(self, button, down)
        if btn:IsVisible() and not down then
            btn:SetButtonState("NORMAL")
        end
    end)

    wahkButtons[buttonName] = wahkBtn
    return wahkBtn
end

local function updateBinds()
    if InCombatLockdown() then
        wahkHeader:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    ClearOverrideBindings(binderFrame)
    UnregisterStateDriver(binderFrame, "overridebutton")

    binderFrame:SetAttribute("_onstate-overridebutton", nil)
    binderFrame:SetAttribute("wahk_override_state", "normal")
    binderFrame:SetAttribute("wahk_count", 0)

    wipe(boundKeys)

    local binds = GetAllBindings()
    local bindingIndex = 0

    for btnName, keys in pairs(binds) do
        local btn = _G[btnName]
        
        if btn and keys and #keys > 0 then
            local normalWahk = addWAHK(btnName, btn)
            local overrideWahkName = ""

            local actionBtnNum = tonumber(btnName:match("^ActionButton(%d+)$"))
            local overrideBtn = actionBtnNum and _G["OverrideActionBarButton" .. actionBtnNum]

            if actionBtnNum and actionBtnNum <= 6 and overrideBtn then
                local overrideWahk = addWAHK(btnName .. "_override", overrideBtn, true)
                overrideWahkName = overrideWahk:GetName()
            end

            for _, key in ipairs(keys) do
                if not boundKeys[key] then
                    bindingIndex = bindingIndex + 1

                    binderFrame:SetAttribute("wahk_key" .. bindingIndex, key)
                    binderFrame:SetAttribute("wahk_normal" .. bindingIndex, normalWahk:GetName())
                    binderFrame:SetAttribute("wahk_override" .. bindingIndex, overrideWahkName)
                    boundKeys[key] = true
                end
            end
        end
    end

    binderFrame:SetAttribute("wahk_count", bindingIndex)

    if bindingIndex > 0 then
        binderFrame:SetAttribute("_onstate-overridebutton", SECURE_ONSTATE_OVERRIDEBUTTON)
        RegisterStateDriver(binderFrame, "overridebutton", "[overridebar] override; [vehicleui] override; normal")
        binderFrame:Execute(SECURE_APPLY_BINDINGS)
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