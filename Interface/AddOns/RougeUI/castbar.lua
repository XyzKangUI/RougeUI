local _, RougeUI = ...
local strformat, max = string.format, math.max

local function PurpleKoolaid(statusbar)
    if (not statusbar or statusbar.disconnected) then
        return
    end

    local min, max = statusbar:GetMinMaxValues()
    if (max <= min) then
        return
    end

    local value = statusbar:GetValue()
    if ((value < min) or (value > max)) then
        return
    end

    value = (value - min) / (max - min)

    local startR, startG, startB = 0.7, 0.3, 1.0
    local endR, endG, endB = 0.49803921568, 0, 1.0

    local progress = value * value

    local r = startR + (endR - startR) * progress
    local g = startG + (endG - startG) * progress
    local b = startB + (endB - startB) * progress

    statusbar:SetStatusBarColor(r, g, b)
end

local function setFont(textString, size)
    local fontType
    if LOCALE_koKR then
        fontType = "Fonts\\2002.TTF"
    elseif LOCALE_zhTW then
        fontType = "Fonts\\arheiuhk_bd.TTF"
    elseif LOCALE_zhCN then
        fontType = "Fonts\\ARKai_C.ttf"
    elseif LOCALE_ruRU then
        fontType = "Fonts\\FRIZQT___CYR.TTF"
    else
        fontType = "Fonts\\FRIZQT__.TTF"
    end

    textString:SetFont(fontType, size, "OUTLINE")
end

local function modstyle()
    for _, t in pairs { TargetFrameSpellBar, FocusFrameSpellBar } do
        if t then
            t.timer = t:CreateFontString(nil, "OVERLAY")
            setFont(t.timer, 9)
            t.timer:SetShadowColor(0, 0, 0)
            t.timer:SetShadowOffset(0, 0)
            t.timer:SetPoint("RIGHT", t, -2.5, 0)
            t.update = .1

            setFont(t.Text, 10)
            t.Text:SetShadowOffset(0, 0)
            t.Text:SetJustifyH("LEFT")
            t.Text:ClearAllPoints()
          --  t.Text:SetPoint("CENTER", t, "CENTER", 0, 0.5)
          --  t.Text:SetPoint("LEFT", t, "LEFT", 5, 0.5)
            t.Text:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 2, -5)
            t.Spark:SetAlpha(0.7)
            t.Spark:SetSize(15, 15)
            t.BorderShield:SetAlpha(0.7)
        end
    end

    local cf = CastingBarFrame
    cf.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
    cf.Border:SetWidth(cf.Border:GetWidth() + 4)
    cf.Border:ClearAllPoints()
    cf.Border:SetPoint("TOP", 0, 26)
    cf.Flash:SetWidth(cf.Flash:GetWidth() + 4)
    cf.Flash:ClearAllPoints()
    cf.Flash:SetPoint("TOP", 0, 26)
    cf.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")

    cf.Spark:SetAlpha(0.7)
    cf.Spark:SetHeight(40)
    cf.Spark:SetHeight(50)
    cf.Text:ClearAllPoints()
    cf.Text:SetPoint("CENTER", 0, 0)
    setFont(cf.Text, 11)

    cf.timer = cf:CreateFontString(nil, "OVERLAY")
    cf.timer:SetShadowColor(0, 0, 0)
    cf.timer:SetShadowOffset(1, -1)
    cf.timer:SetPoint("RIGHT", cf, -2.5, -0.5)
    cf.timer:SetScale(1.15)
    cf.update = .1
    setFont(cf.timer, 9)
end



local function TimerHook(self, elapsed)
    if not self.timer then
        return
    end

    self.update = (self.update or 0) - elapsed

    if self.update <= 0 then
        local remainingTime = 0

        if self.casting then
            remainingTime = max(self.maxValue - self.value, 0)
        elseif self.channeling then
            remainingTime = max(self.value, 0)
        end

        self.timer:SetText(strformat("%.1f", remainingTime))
        self.update = 0.1
    end
end

local spellDurations = {}
local isSoD = C_Seasons and (C_Seasons.GetActiveSeason() == Enum.SeasonID.SeasonOfDiscovery)
if isSoD then
    spellDurations = {
        [GetSpellInfo(605)] = 60, -- Mind Control
        [GetSpellInfo(1949)] = 15, -- Hellfire
        [GetSpellInfo(16914)] = 10, -- Hurricane
        [GetSpellInfo(10)] = 8, -- Blizzard
        [GetSpellInfo(15407)] = 3, -- Mind Flay
        [GetSpellInfo(413259)] = 5, -- Mind Sear
        [GetSpellInfo(437169)] = 120, -- Portal of Summoning
        [GetSpellInfo(412510)] = 3, -- Mass Regeneration
        [GetSpellInfo(401417)] = 3, -- Regeneration
        [GetSpellInfo(698)] = 5, -- Ritual of summoning
        [GetSpellInfo(402174)] = 2, -- Penance
        [GetSpellInfo(1515)] = 20, -- Tame Beast
        [GetSpellInfo(5740)] = 8, -- Rain of Fire
        [GetSpellInfo(1002)] = 60, -- Eye of the beast
        [GetSpellInfo(6197)] = 60, -- Eagle eye
        [GetSpellInfo(18540)] = 10, -- Ritual of doom
        [GetSpellInfo(435167)] = 10, -- Miniaturized Combustion Chamber
        [GetSpellInfo(1120)] = 15, -- Drain Soul
        [GetSpellInfo(8989)] = 10, -- Whirlwind
        [GetSpellInfo(2096)] = 60, -- Mind Vision
        [GetSpellInfo(12051)] = 8, -- Evocation
        [GetSpellInfo(438714)] = 10, -- Furnace Surge
        [GetSpellInfo(7290)] = 10, -- Soul Siphon
        [GetSpellInfo(433797)] = 7, -- Bladestorm
        [GetSpellInfo(5138)] = 5, -- Drain Mana
        [GetSpellInfo(746)] = 6, -- First Aid
        [GetSpellInfo(1009)] = 5, -- Savage Pummel
        [GetSpellInfo(1510)] = 6, -- Volley
        [GetSpellInfo(10797)] = 6, -- Starshards
        [GetSpellInfo(136)] = 5, -- Mend Pet
        [GetSpellInfo(755)] = 10, -- Health Funnel
        [GetSpellInfo(17767)] = 10, -- Consume Shadows
        [GetSpellInfo(740)] = 10, -- Tranquility
        [GetSpellInfo(6358)] = 1.5, -- Seduction
        [GetSpellInfo(6196)] = 60, -- Far Sight
        [GetSpellInfo(126)] = 60, -- Eye of Kilrogg
        [GetSpellInfo(7620)] = 30, -- Fishing
        [GetSpellInfo(401460)] = 1.5, -- Rapid Regeneration
        [GetSpellInfo(429820)] = 10, -- Starfall
        [GetSpellInfo(13278)] = 4, -- Gnomish Death Ray
        [GetSpellInfo(20577)] = 10, -- Cannibalize
        [GetSpellInfo(447548)] = 10, -- Twisted Tranquility
        [GetSpellInfo(446101)] = 30, -- Atal'ai Blood Ceremony
        [GetSpellInfo(446586)] = 3, -- Dizzying Spin
        [GetSpellInfo(449431)] = 8, -- Starfall
    }
end

local missileId = {
    [5143] = 3,
    [8417] = 5,
    [25345] = 5,
    [5145] = 5,
    [10212] = 5,
    [8416] = 5,
    [5144] = 4,
    [10211] = 5,
}

local FR = CreateFrame("Frame")
FR:RegisterEvent("PLAYER_LOGIN")
FR:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if isSoD and not IsAddOnLoaded("ClassicCastbars") then
            hooksecurefunc("CastingBarFrame_OnEvent", function(self, event, unit, _, spellId)
                if (unit ~= self.unit) then
                    return
                end

                if event == "UNIT_SPELLCAST_CHANNEL_START" then
                    local name, _, icon = GetSpellInfo(spellId)
                    local duration, startTime, endTime, now = spellDurations[name] or missileId[spellId], nil, nil, GetTime()
                    local desc = GetSpellDescription(spellId)

                    if UnitIsUnit("target", "player") then
                        name, _, icon, startTime, endTime, _, _, spellId = UnitChannelInfo("player")
                        duration = 0
                    end

                    if not name then
                        self:Hide()
                        return
                    end

                    if not duration then
                        if desc and desc ~= "" then
                            local highestSec = 0
                            for dur in desc:gmatch("(%d+)%s-[Ss]ec") do
                                local val = tonumber(dur)
                                if val and val > highestSec then
                                    highestSec = val
                                end
                            end
                            duration = (highestSec and highestSec > 0) and highestSec or nil
                        else
                            return
                        end
                    end

                    if (name and duration) then
                        local startColor = CastingBarFrame_GetEffectiveStartColor(self, true)
                        if self.flashColorSameAsStart then
                            self.Flash:SetVertexColor(startColor:GetRGB())
                        else
                            self.Flash:SetVertexColor(1, 1, 1)
                        end
                        self:SetStatusBarColor(startColor:GetRGB())
                        if not endTime then
                            startTime = now * 1000
                            endTime = startTime + (duration * 1000)
                        end
                        self.value = (endTime / 1000) - now
                        self.maxValue = (endTime - startTime) / 1000
                        self:SetMinMaxValues(0, self.maxValue)
                        self:SetValue(self.value)

                        if self.Text then
                            self.Text:SetText(name)
                        end
                        if self.Icon then
                            if not icon or (icon == 136235) then
                                icon = 0
                            end
                            self.Icon:SetTexture(icon)
                        end
                        CastingBarFrame_ApplyAlpha(self, 1.0)
                        self.holdTime = 0
                        self.casting = nil
                        self.channeling = true
                        self.fadeOut = nil
                        self.spellActive = spellId
                        if self.showCastbar then
                            self:Show()
                        end
                    end
                end
            end)
        end
        if RougeUI.db.CastTimer then
            modstyle()

            for _, v in pairs { TargetFrameSpellBar, FocusFrameSpellBar } do
                if v then
                    v:HookScript("OnUpdate", function(self, elapsed)
                        TimerHook(self, elapsed)
                        if self.BorderShield and self.BorderShield:IsShown() then
                            self:SetStatusBarColor(0.94, 0.94, 0.94)
                        else
                            RougeUI.RougeUIF:GradientColour(self)
                        end
                        if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                            self:SetStatusBarColor(216 / 255, 31 / 255, 42 / 255)
                        end
                    end)
                end
            end

            CastingBarFrame:HookScript("OnUpdate", function(self, elapsed)
                TimerHook(self, elapsed)
                PurpleKoolaid(self)
                if self.Text and (self.Text:GetText() == INTERRUPTED or self.Text:GetText() == FAILED) then
                    self:SetStatusBarColor(216 / 255, 31 / 255, 42 / 255)
                end
            end)
        end
    end
end)