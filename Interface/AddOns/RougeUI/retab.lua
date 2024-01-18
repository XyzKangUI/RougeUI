local _, RougeUI = ...
local RE = CreateFrame("Frame")
RE:RegisterEvent("PLAYER_ENTERING_WORLD")

local key = "TAB"
local button = CreateFrame("Button", "Tabber", nil, "SecureActionButtonTemplate")
button:RegisterForClicks("AnyDown")
button:SetAttribute("type", "macro")
SecureHandlerWrapScript(button, "OnClick", button, [[
     if down then
         self:SetAttribute("macrotext","/targetenemyplayer\n/targetlasttarget [noexists]")
     end]])

local function Retabbind()
    local _, instanceType = IsInInstance()

    if InCombatLockdown() then
		RE:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    if (instanceType == "arena" or instanceType == "pvp") then
        SetOverrideBindingClick(button, true, key, "Tabber")
        SetCVar("TargetEnemyAttacker", 0)
    else
        ClearOverrideBindings(button)
        SetCVar("TargetEnemyAttacker", 1)
    end
end

RE:SetScript("OnEvent", function(self, event, ...)
    if not RougeUI.db.retab then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        self:SetScript("OnEvent", nil)
        return
    end
    if event == "PLAYER_ENTERING_WORLD" then
        Retabbind()
	elseif event == "PLAYER_REGEN_ENABLED" then
		Retabbind()
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
end)