local _, RougeUI = ...
local _G = getfenv(0)

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
f:SetScript("OnEvent", function()
    HookFrames()

    DropDownList1Button1NormalText:HookScript("OnShow", function()
        local text = DropDownList1Button1NormalText:GetText()
        if text:find("cfff58cba") then
            local newText = string.gsub(text, "|cfff58cba", "|cff0070de")
            DropDownList1Button1NormalText:SetText(newText)
        end
    end)

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
end)