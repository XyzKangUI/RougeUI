local f = CreateFrame("Frame", nil, UIParent, "SecureHandlerMouseUpDownTemplate")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if addon == "RougeUI" then
        local prev, next = _G["SpellBookPrevPageButton"]:GetName(), _G["SpellBookNextPageButton"]:GetName()
        if prev then
            SetOverrideBindingClick(f, true, "MOUSEWHEELUP", prev)
        end
        if next then
            SetOverrideBindingClick(f, true, "MOUSEWHEELDOWN", next)
        end
    end
end)

if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
    EventUtil.ContinueOnAddOnLoaded("Blizzard_Collections", function()
        MountJournal:HookScript("OnShow", function(self)
            CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\MountJournalPortrait")
        end)
        ToyBox:HookScript("OnShow", function(self)
            CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\Trade_Archaeology_ChestofTinyGlassAnimals")
        end)
        HeirloomsJournal:HookScript("OnShow", function(self)
            CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\inv_misc_enggizmos_19")
        end)
        WardrobeCollectionFrame:HookScript("OnShow", function(self)
            CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\inv_chest_cloth_17")
        end)
    end)
end