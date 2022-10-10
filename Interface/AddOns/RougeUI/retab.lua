local SetBinding = SetBinding
local RE = CreateFrame("Frame")
RE:RegisterEvent("PLAYER_ENTERING_WORLD")

local function Retabbind()
	local inInstance, instanceType = IsInInstance()

	if InCombatLockdown() then return end

	if (instanceType == "arena" or instanceType == "pvp") then
		SetBinding("TAB", "TARGETNEARESTENEMYPLAYER", 1)
	else
		SetBinding("TAB", "TARGETNEARESTENEMY", 1)
	end
end

RE:SetScript("OnEvent", function(self, event, ...)
	if not RougeUI.retab then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:SetScript("OnEvent", nil)
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
        	Retabbind()
    	end
end)