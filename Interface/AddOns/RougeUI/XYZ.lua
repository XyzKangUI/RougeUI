local _, RougeUI = ...
local wahkButtons = {}
local boundKeys = {}
local pendingUpdate

local binderFrame = CreateFrame("Frame", nil, nil, "SecureHandlerStateTemplate")

local SECURE_APPLY_BINDINGS = [[
	local state = self:GetAttribute("wahk_override_state") or "normal"
	local count = self:GetAttribute("wahk_count") or 0

	self:ClearBindings()

	for i = 1, count do
		local key = self:GetAttribute("wahk_key" .. i)
		local normal = self:GetAttribute("wahk_normal" .. i)
		local vehicle = self:GetAttribute("wahk_vehicle" .. i)
		local bonus = self:GetAttribute("wahk_bonus" .. i)

		if vehicle == "" then vehicle = nil end
		if bonus == "" then bonus = nil end

		local target = normal

		if state == "vehicle" and vehicle then
			target = vehicle
		elseif state == "bonus" and bonus then
			target = bonus
		end

		if key and target then
			self:SetBindingClick(true, key, target, "LeftButton")
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
}

local function BuildAllBindings()
	local result = {}
	local seenKeys = {}

	local function ScanKey(key)
		if key and key ~= "" then seenKeys[key] = true end
	end

	local function ScanCommand(command)
		local key1, key2 = GetBindingKey(command)
		ScanKey(key1)
		ScanKey(key2)
	end

	for i = 1, GetNumBindings() do
		local command, key1, key2 = GetBinding(i)
		ScanKey(key1)
		ScanKey(key2)
	end

	for i = 1, 120 do
		ScanCommand("CLICK BT4Button"..i..":LeftButton")
		ScanCommand("CLICK DominosActionButton"..i..":HOTKEY")
		ScanCommand("CLICK DominosActionButton"..i..":LeftButton")
	end

	for key in pairs(seenKeys) do
		local action = GetBindingAction(key, true)		
		if action and action ~= "" then
			local btnName
			
			if action:match("^CLICK ") then
				btnName = action:match("^CLICK ([^:]+)")
			else
				local base, id = action:match("^(.-)(%d+)$")
				if base and id then
					local blizzBtn = defaultButtons[base:upper()]
					if blizzBtn then
						btnName = blizzBtn .. id
					end
				end
			end

			if btnName then
				result[btnName] = result[btnName] or {}
				table.insert(result[btnName], key)
			end
		end
	end

	return result
end

local function addWAHK(buttonName, btn)
    local wahkBtn = wahkButtons[buttonName]
    if wahkBtn then return wahkBtn end

    wahkBtn = CreateFrame("Button", "WAHK_" .. buttonName, nil, "SecureActionButtonTemplate")
    wahkBtn:RegisterForClicks("AnyUp", "AnyDown")
    wahkBtn:SetAttribute("type", "click")
    wahkBtn:SetAttribute("clickbutton", btn)

    wahkBtn:SetScript("OnMouseDown", function()
        if btn:IsVisible() then
            btn:SetButtonState("PUSHED")
            if RougeUI and RougeUI.db and RougeUI.db.ButtonAnim then
                RougeUI.Animate(btn)
            end
        end
    end)

    wahkBtn:SetScript("OnMouseUp", function()
        if btn:IsVisible() then
            btn:SetButtonState("NORMAL")
            if RougeUI and RougeUI.db and RougeUI.db.ButtonAnim and RougeUI.db.wahksfk then
                RougeUI.Animate(btn)
            end
        end
    end)
    
    wahkBtn:SetScript("PostClick", function()
        if btn:IsVisible() then
            btn:SetButtonState("NORMAL")
        end
    end)

    wahkButtons[buttonName] = wahkBtn
    return wahkBtn
end

local function updateBinds()
    if InCombatLockdown() then
        binderFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    ClearOverrideBindings(binderFrame)
    UnregisterStateDriver(binderFrame, "overridebutton")

    binderFrame:SetAttribute("_onstate-overridebutton", nil)
    binderFrame:SetAttribute("wahk_override_state", "normal")
    binderFrame:SetAttribute("wahk_count", 0)

    wipe(boundKeys)

    local binds = BuildAllBindings()
    local bindingIndex = 0

    for btnName, keys in pairs(binds) do
        local btn = _G[btnName]
        
        if btn and keys and #keys > 0 then
            local normalWahk = addWAHK(btnName, btn)
            local vehicleWahkName = ""
            local bonusWahkName = ""

            local actionBtnNum = tonumber(btnName:match("^ActionButton(%d+)$"))

            if actionBtnNum then
                local vehicleBtn = _G["VehicleMenuBarActionButton" .. actionBtnNum]
                if vehicleBtn then
                    local vehicleWahk = addWAHK(btnName .. "_vehicle", vehicleBtn)
                    vehicleWahkName = vehicleWahk:GetName()
                end

                local bonusBtn = _G["BonusActionButton" .. actionBtnNum]
                if bonusBtn then
                    local bonusWahk = addWAHK(btnName .. "_bonus", bonusBtn)
                    bonusWahkName = bonusWahk:GetName()
                end
            end

            for _, key in ipairs(keys) do
                if not boundKeys[key] then
                    bindingIndex = bindingIndex + 1
                    binderFrame:SetAttribute("wahk_key" .. bindingIndex, key)
                    binderFrame:SetAttribute("wahk_normal" .. bindingIndex, normalWahk:GetName())
                    binderFrame:SetAttribute("wahk_vehicle" .. bindingIndex, vehicleWahkName)
                    binderFrame:SetAttribute("wahk_bonus" .. bindingIndex, bonusWahkName)
                    boundKeys[key] = true
                end
            end
        end
    end

    binderFrame:SetAttribute("wahk_count", bindingIndex)

    if bindingIndex > 0 then
        binderFrame:SetAttribute("_onstate-overridebutton", SECURE_ONSTATE_OVERRIDEBUTTON)
        RegisterStateDriver(binderFrame, "overridebutton", "[vehicleui] vehicle; [bonusbar:1/2/3/4/5] bonus; normal")
        binderFrame:Execute(SECURE_APPLY_BINDINGS)
    end
end

local timerFrame = CreateFrame("Frame")
local updateTimer = 0
local function scheduledUpdate()
    if pendingUpdate then return end
    pendingUpdate = true
    updateTimer = 0.5
    timerFrame:SetScript("OnUpdate", function(self, elapsed)
        updateTimer = updateTimer - elapsed
        if updateTimer <= 0 then
            self:SetScript("OnUpdate", nil)
            pendingUpdate = nil
            updateBinds()
        end
    end)
end

binderFrame:RegisterEvent("PLAYER_LOGIN")
binderFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" and RougeUI and RougeUI.db and RougeUI.db.KeyEcho then
        self:RegisterEvent("UPDATE_BINDINGS")
        scheduledUpdate()
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        scheduledUpdate()
    elseif event ~= "PLAYER_LOGIN" then
        scheduledUpdate()
    end
end)