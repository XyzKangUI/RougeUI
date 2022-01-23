local SetBinding = SetBinding
local RE = CreateFrame("Frame")
RE:RegisterEvent("PLAYER_ENTERING_WORLD")

local function Retabbind()
	local inInstance, instanceType = IsInInstance()
	if not RougeUI.retab then
		RE:UnregisterEvent("PLAYER_ENTERING_WORLD")
		return
	end

	if InCombatLockdown() then return end

	if (instanceType == "arena" or instanceType == "pvp") then
		SetBinding("TAB", "TARGETNEARESTENEMYPLAYER", 1)
		print("\124cFF74D06C[Retab]\124r PVP Mode")
	else
		SetBinding("TAB", "TARGETNEARESTENEMY", 1)
		print("\124cFF74D06C[Retab]\124r PVE Mode")
	end
end

RE:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
        	Retabbind()
    	end
end)