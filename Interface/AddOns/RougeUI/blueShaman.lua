local IsAddOnLoaded = IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local blueShaman = { r = 0.0, g = 0.44, b = 0.87, colorStr = "ff0070de" }

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if event == "PLAYER_LOGIN" then
        if IsAddOnLoaded("!WeWantBlueShamans") then
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
            return
        end

        -- Nameplate & Raid Frames healthBar
        hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
            if not frame.unit or frame:IsForbidden() then
                return
            end

            if UnitIsConnected(frame.unit) and UnitIsPlayer(frame.unit) and frame.optionTable.useClassColors then
                local _, class = UnitClass(frame.unit)
                if class == "SHAMAN" then
                    frame.healthBar:SetStatusBarColor(0, 0.44, 0.87)
                end
            end
        end)

        if UnitFactionGroup("player") == "Alliance" then
            self:UnregisterAllEvents()
            return
        end

        -- /who list
        hooksecurefunc("WhoList_Update", function()
            local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
            local whoIndex, class
            for i = 1, WHOS_TO_DISPLAY, 1 do
                whoIndex = whoOffset + i
                local info = C_FriendList.GetWhoInfo(whoIndex)
                if info and info.filename == "SHAMAN" then
                    _G["WhoFrameButton" .. i .. "Class"]:SetTextColor(0.0, 0.44, 0.87)
                end
            end
        end)

        -- Dropdown list
        DropDownList1Button1NormalText:HookScript("OnShow", function()
            local text = DropDownList1Button1NormalText:GetText()
            if text:find("cfff58cba") then
                local newText = string.gsub(text, "|cfff58cba", "|cff0070de")
                DropDownList1Button1NormalText:SetText(newText)
            end
        end)

        -- ChatFrame
        local newClassColors = {}
        for class, color in pairs(RAID_CLASS_COLORS) do
            newClassColors[class] = class == "SHAMAN" and blueShaman or color
        end

        setfenv(GetColoredName, setmetatable({}, {
            __index = function(t, k)
                if k == "RAID_CLASS_COLORS" then
                    return newClassColors
                else
                    return _G[k]
                end
            end
        }))

        -- Leatrix Maps pins
        if IsAddOnLoaded("Leatrix_Maps") then
            if LeaMapsDB["UseClassIcons"] == "On" then
                for k in pairs(WorldMapFrame.dataProviders) do
                    if k.pin and k.pin.SetUnitAppearanceInternal then
                        hooksecurefunc(k.pin, 'SetUnitAppearanceInternal', function(self, timeNow, unit, appearanceData)
                            if appearanceData.shouldShow and appearanceData.useClassColor then
                                local _, class = UnitClass(unit)
                                local c = (class == "SHAMAN" and blueShaman) or RAID_CLASS_COLORS[class]
                                if c then
                                    self:SetUnitColor(unit, c.r, c.g, c.b, 1)
                                end
                            end
                        end)
                    end
                end
            end
        end
    elseif event == "ADDON_LOADED" and addon == "Blizzard_RaidUI" then
        -- RaidGroupButtons
        hooksecurefunc("RaidGroupFrame_Update", function()
            local isRaid = IsInRaid();
            local numRaidMembers = GetNumGroupMembers();

            if not isRaid then
                return
            end
            for i = 1, MAX_RAID_MEMBERS do
                if isRaid and (i <= numRaidMembers) then
                    local _, _, _, _, _, fileName, _, online, isDead = GetRaidRosterInfo(i);
                    local color = (fileName == "SHAMAN") and blueShaman or RAID_CLASS_COLORS[fileName]
                    if color and online and not isDead then
                        local button = _G["RaidGroupButton" .. i]
                        if button then
                            if button.subframes.name then
                                button.subframes.name:SetTextColor(color.r, color.g, color.b)
                            end
                            if button.subframes.class.text then
                                button.subframes.class.text:SetTextColor(color.r, color.g, color.b)
                            end
                            if button.subframes.level then
                                button.subframes.level:SetTextColor(color.r, color.g, color.b)
                            end
                        end
                    end
                end
            end
        end)
    end
end)