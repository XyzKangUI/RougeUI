local _, RougeUI = ...
local frame = CreateFrame("Frame")
local _G = getfenv(0)
local cacheKeys = {}
local pairs, ipairs, tonumber, type = _G.pairs, _G.ipairs, _G.tonumber, _G.type
local unpack, tblinsert, strmatch = _G.unpack, _G.table.insert, _G.string.match
local IsAddOnLoaded = IsAddOnLoaded

local buttonNames = {
	["ACTIONBUTTON"] = "ActionButton",
	["MULTIACTIONBAR1BUTTON"] = "MultiBarBottomLeftButton",
	["MULTIACTIONBAR2BUTTON"] = "MultiBarBottomRightButton",
	["MULTIACTIONBAR3BUTTON"] = "MultiBarRightButton",
	["MULTIACTIONBAR4BUTTON"] = "MultiBarLeftButton",
	["CLICK BT4Button"] = "BT4Button",
	["CLICK DominosActionButton"] = "DominosActionButton",
}

local function GetActionButton(slotID)
	local names = {}
	local button = 1 + (slotID - 1) % 12

	if slotID <= 12 then
		tblinsert(names, "ACTIONBUTTON" .. button)
	elseif slotID <= 24 then
		tblinsert(names, "MULTIACTIONBAR1BUTTON" .. button)
	elseif slotID <= 36 then
		tblinsert(names, "MULTIACTIONBAR2BUTTON" .. button)
	elseif slotID <= 48 then
		tblinsert(names, "MULTIACTIONBAR3BUTTON" .. button)
	elseif slotID <= 60 then
		tblinsert(names, "MULTIACTIONBAR4BUTTON" .. button)
	elseif slotID <= 72 then
		tblinsert(names, "MULTIACTIONBAR5BUTTON" .. button)
	elseif slotID <= 84 then
		tblinsert(names, "MULTIACTIONBAR6BUTTON" .. button)
	elseif slotID <= 96 then
		tblinsert(names, "MULTIACTIONBAR7BUTTON" .. button)
	end

	if IsAddOnLoaded("Bartender4") and slotID >= 1 and slotID <= 120 then
		tblinsert(names, "CLICK BT4Button" .. slotID .. ":Keybind")
	elseif IsAddOnLoaded("Dominos") and slotID >= 1 and slotID <= 120 then
		tblinsert(names, "CLICK DominosActionButton" .. slotID .. ":HOTKEY")
	end

	return unpack(names)
end

local function ConvertActionButtonName(name)
	-- remove "CLICK "
	name = name:gsub("^CLICK ", "")

	-- remove ":Keybind"
	name = name:gsub(":Keybind$", "")

	if IsAddOnLoaded("Dominos") then
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

local function GetButtonKeyBindings(...)
	local buttonNames = {...}

	for _, buttonName in ipairs(buttonNames) do
		local key1, key2 = GetBindingKey(buttonName)
		if key1 then
			cacheKeys[key1] = true
		end

		if key2 then
			cacheKeys[key2] = true
		end
	end
end

local function UpdateBinds()
	if InCombatLockdown() then
		frame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	ClearOverrideBindings(frame)

	for i = 1, GetNumBindings() do
		local button1, button2 = GetActionButton(i)
		GetButtonKeyBindings(button1, button2)

		for key in pairs(cacheKeys) do
			local action = GetBindingAction(key, true)

			if (not action) or (action == "") then
				return
			end

			local btn = _G[ConvertActionButtonName(action)]
			if btn then
				if type(btn) == "table" and btn:IsProtected() then
					btn:RegisterForClicks("AnyDown", "AnyUp")
					if IsAddOnLoaded("Dominos") then
						SecureHandlerUnwrapScript(btn, "OnClick")
					end
					SetOverrideBindingClick(frame, true, key, btn:GetName())
				end
			end
		end
	end
end

frame:RegisterEvent("UPDATE_BINDINGS")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
	if not RougeUI.db.KeyEcho then -- stop copying my work, use the addon.
		self:UnregisterAllEvents()
		self:SetScript("OnEvent", nil)
		return
	end
	if event == "UPDATE_BINDINGS" or event == "PLAYER_LOGIN" then
		UpdateBinds()
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		UpdateBinds()
	end
end)