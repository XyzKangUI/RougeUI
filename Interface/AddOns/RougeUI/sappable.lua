local plates = {}

local sappableLocales = {
	'Humanoid', 'Humanoide', 'Humanoïde', 'Umanoide', 'Humanoide', 'Гуманоид', '인간형', '인간형', '人型生物',
	'Demon', 'Dämon', 'Demonio', 'Demonio', 'Démon', 'Demone', 'Demônio', 'Демон', '악마', '恶魔', '惡魔',
	'Beast', 'Wildtier', 'Bestia', 'Bestia', 'Bête', 'Bestia', 'Fera', 'Животное', '야수', '野兽', '野獸',
	'Dragonkin', 'Drachkin', 'Dragon', 'Dragón', 'Draconien', 'Dragoide', 'Dracônico', 'Дракон', '용족', '龙类', '龍類'
};

local function CreatureCanBeSapped(unit)
	creatureType = UnitCreatureType(unit)
	for _,value in pairs(sappableLocales) do
		if (value == creatureType) then
                	return true;
		end
	end
	
	return false;
end;

local function IsSappable(unit)
    return (not UnitAffectingCombat(unit) and CreatureCanBeSapped(unit))
end

local function CreateSapIcon(unit, unitGUID)
    local plate = C_NamePlate.GetNamePlateForUnit(unit)

    if not plate.indicator then
        plate.indicator = plate:CreateTexture(nil, "OVERLAY")
        plate.indicator:SetTexture("Interface\\Icons\\ABILITY_SAP");
        plate.indicator:SetSize(20, 20)
        plate.indicator:SetPoint("LEFT", -20, -10)
        plate.indicator:Hide()
    end

    plate.indicator.unit = unit
    if IsSappable(unit) then
        plate.indicator:Show()
    end
    plates[unitGUID] = plate
end

local function UpdateIndicator(unit, unitGUID)
    if plates[unitGUID] then
        if IsSappable(unit) then
            plates[unitGUID].indicator:Show()
        else
            plates[unitGUID].indicator:Hide()
        end
    end
end

local function Remove(unitGUID)
    if plates[unitGUID] then
        plates[unitGUID].indicator:Hide()
    end
    plates[unitGUID] = nil
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
frame:RegisterEvent("UNIT_FLAGS")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, ...)
    if not RougeUI.sappable then
        self:UnregisterAllEvents()
	  self:SetScript("OnEvent", nil)
    end

    if event == "PLAYER_ENTERING_WORLD" then
        plates = {}
    else
        local unit = ...
        local unitGUID = UnitGUID(unit)
        if event == "NAME_PLATE_UNIT_ADDED" then
            CreateSapIcon(unit, unitGUID)
        elseif event == "NAME_PLATE_UNIT_REMOVED" then
            Remove(unitGUID)
        elseif event == "UNIT_FLAGS" then
            UpdateIndicator(unit, unitGUID)
        end
    end
end)