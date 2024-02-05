local _, RougeUI = ...
local strsub, string_format = string.sub, string.format
local RAID_CLASS_COLORS, Ambiguate, GetPlayerInfoByGUID = RAID_CLASS_COLORS, Ambiguate, GetPlayerInfoByGUID
local ChatTypeInfo = ChatTypeInfo
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded

local function ShamanBlue(...)
    local frame, r, g, b = ...
    if not frame or not (r == 0.96 and g == 0.55 and b == 0.73) then
        return
    end
    if frame.ChangingColor then
        return
    end

    frame.ChangingColor = true

    if frame:GetObjectType() == "StatusBar" then
        frame:SetStatusBarColor(0.0, 0.44, 0.87)
    elseif frame:GetObjectType() == "FontString" then
        frame:SetTextColor(0.0, 0.44, 0.87)
    end

    frame.ChangingColor = false
end

local function HookFrames()
    for frameName, frame in pairs(_G) do
        if type(frame) == "table" and frame.GetObjectType then
            --if frame.SetStatusBarColor and frameName:match("HealthBar") and RougeUI.db.ClassHP then
            --    hooksecurefunc(frame, "SetStatusBarColor", ShamanBlue) -- bit overkill when we hook colors in extra.lua
            if frame.SetTextColor and frameName:match("WhoFrameButton%d+Class") then
                hooksecurefunc(frame, "SetTextColor", ShamanBlue)
            end
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if event == "PLAYER_LOGIN" then
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

        hooksecurefunc("WhoList_Update", function()
            local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
            local whoIndex, class
            for i = 1, WHOS_TO_DISPLAY, 1 do
                whoIndex = whoOffset + i
                local info = C_FriendList.GetWhoInfo(whoIndex)
                if info then
                    class = info.filename
                end
                if class == "SHAMAN" then
                    _G["WhoFrameButton" .. i .. "Class"]:SetTextColor(0.0, 0.44, 0.87)
                end
            end
        end)

        DropDownList1Button1NormalText:HookScript("OnShow", function()
            local text = DropDownList1Button1NormalText:GetText()
            if text:find("cfff58cba") then
                local newText = string.gsub(text, "|cfff58cba", "|cff0070de")
                DropDownList1Button1NormalText:SetText(newText)
            end
        end)

        function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
            local chatType = strsub(event, 10);
            if (strsub(chatType, 1, 7) == "WHISPER") then
                chatType = "WHISPER";
            end
            if (strsub(chatType, 1, 7) == "CHANNEL") then
                chatType = "CHANNEL" .. arg8;
            end
            local info = ChatTypeInfo[chatType];

            --ambiguate guild chat names
            if (chatType == "GUILD") then
                arg2 = Ambiguate(arg2, "guild")
            else
                arg2 = Ambiguate(arg2, "none")
            end

            if (info and info.colorNameByClass and arg12 and arg12 ~= "") then
                local _, englishClass = GetPlayerInfoByGUID(arg12)

                if (englishClass) then
                    local classColorTable = RAID_CLASS_COLORS[englishClass];
                    if (not classColorTable) then
                        return arg2;
                    end
                    if englishClass == "SHAMAN" then
                        return "\124cff0070de" .. arg2 .. "\124r"
                    else
                        return string_format("\124cff%.2x%.2x%.2x", classColorTable.r * 255, classColorTable.g * 255, classColorTable.b * 255) .. arg2 .. "\124r"
                    end
                end
            end

            return arg2;
        end

        if IsAddOnLoaded("Leatrix_Maps") then
            local WorldMapUnitPin, firstRun
            if LeaMapsDB["UseClassIcons"] == "On" then
                for pin in WorldMapFrame:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
                    WorldMapUnitPin = pin
                    hooksecurefunc(WorldMapUnitPin, "SetAppearanceField", function(self, unit)
                        local _, class = UnitClass(unit)
                        local c = RAID_CLASS_COLORS[class]
                        if c then
                            if class == "SHAMAN" then
                                c.r, c.g, c.b = 0, 0.44, 0.87
                            end
                            self:SetUnitColor(unit, c.r, c.g, c.b, 1)
                        end
                    end)
                end
            end

            if (not BattlefieldMapFrame) then
                BattlefieldMap_LoadUI()
            end

            for pin in BattlefieldMapFrame:EnumerateAllPins() do
                if pin.UpdateAppearanceData then
                    if firstRun then
                        firstRun = true
                        hooksecurefunc(pin, "SetAppearanceField", function(self, unit)
                            local _, class = UnitClass(unit)
                            local c = RAID_CLASS_COLORS[class]
                            if c then
                                if class == "SHAMAN" then
                                    c.r, c.g, c.b = 0, 0.44, 0.87
                                end
                                self:SetUnitColor(unit, c.r, c.g, c.b, 1)
                            end
                        end)
                    end
                end
            end
        end
    elseif event == "ADDON_LOADED" and addon == "Blizzard_RaidUI" then
        if RaidGroupFrame_Update then
            hooksecurefunc("RaidGroupFrame_Update", function()
                local isRaid = IsInRaid();
                local numRaidMembers = GetNumGroupMembers();

                if not isRaid then
                    return
                end
                for i = 1, MAX_RAID_MEMBERS do
                    if isRaid and (i <= numRaidMembers) then
                        local _, _, _, _, _, fileName, _, online, isDead = GetRaidRosterInfo(i);
                        local color = (fileName == "SHAMAN") and { r = 0, g = 0.44, b = 0.87 } or RAID_CLASS_COLORS[fileName]
                        if color and online and not isDead then
                            local button = _G["RaidGroupButton" .. i]
                            if button then
                                button.subframes.name:SetTextColor(color.r, color.g, color.b)
                                button.subframes.class.text:SetTextColor(color.r, color.g, color.b)
                                button.subframes.level:SetTextColor(color.r, color.g, color.b)
                            end
                        end
                    end
                end
            end)
        end
    end
end)