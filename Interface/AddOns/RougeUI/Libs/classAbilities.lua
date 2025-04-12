local lib = LibStub and LibStub("LibClassicDurations", true)
if not lib then
    return
end

local Type, Version = "SpellTable", 72
if lib:GetDataVersion(Type) >= Version then
    return
end  -- older versions didn't have that function

local Spell = lib.AddAura
local INFINITY = math.huge
local GHOST = "hide"
local FAKE = "fake"

------------------
-- GLOBAL
------------------


-- World Buffs incl. Chronoboon IDs
Spell(349981, { duration = INFINITY }) -- World effect suspended
Spell({ 355363, 22888 }, { duration = 7200 }) -- Rallying Cry of the Dragonslayer
Spell({ 355365, 24425 }, { duration = 7200 }) -- Spirit of Zandalar
Spell({ 355366, 16609 }, { duration = 3600 }) -- Warchief's Blessing
Spell(8326, { duration = GHOST }) -- Ghost
Spell({ 439996, 21074, 22012, 2584 }, { duration = GHOST }) -- Resurrection

-- Atiesh Buffs
Spell(28142, { duration = INFINITY, type = "BUFF" }) -- Power of the Guardian
Spell(28143, { duration = INFINITY, type = "BUFF" }) -- Power of the Guardian
Spell(28144, { duration = INFINITY, type = "BUFF" }) -- Power of the Guardian
Spell(28145, { duration = INFINITY, type = "BUFF" }) -- Power of the Guardian

-- Net-o-Matic

Spell(23451, { duration = 10 }) -- Battleground speed buff
Spell(23493, { duration = 10 }) -- Battleground heal buff
Spell(23505, { duration = 60 }) -- Battleground damage buff
Spell(6615, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Free Action Potion
Spell(24364, { duration = 5, type = "BUFF", buffType = "Magic" }) -- Living Action Potion
Spell(3169, { duration = 6, type = "BUFF", buffType = "Magic" }) -- Limited Invulnerability Potion
Spell(16621, { duration = 3, type = "BUFF" }) -- Invulnerable Mail
Spell(11359, { duration = 30, type = "BUFF" }) -- Restorative Potion
Spell(5024, { duration = 10, type = "BUFF" }) -- Skull of Impending Doom
Spell(2379, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Swiftness Potion
Spell(23097, { duration = 5, type = "BUFF" }) -- Fire Reflector
Spell(23131, { duration = 5, type = "BUFF" }) -- Frost Reflector
Spell(23132, { duration = 5, type = "BUFF" }) -- Shadow Reflector
Spell({ 25750, 25747, 25746, 23991 }, { duration = 15, type = "BUFF" }) -- AB Trinkets
Spell(23506, { duration = 20, type = "BUFF" }) -- Arena Grand Master trinket
Spell(29506, { duration = 20, type = "BUFF" }) -- Burrower's Shell trinket
Spell(12733, { duration = 30, type = "BUFF" }) -- Blacksmith trinket
Spell(14530, { duration = 10, type = "BUFF" }) -- Nifty Stopwatch
Spell(14253, { duration = 8, type = "BUFF" }) -- Black Husk Shield
Spell(9175, { duration = 15, type = "BUFF" }) -- Swift Boots
Spell(13141, { duration = 20, type = "BUFF" }) -- Gnomish Rocket Boots
Spell(8892, { duration = 20, type = "BUFF" }) -- Goblin Rocket Boots
Spell(9774, { duration = 5, type = "BUFF" }) -- Spider Belt & Ornate Mithril Boots
Spell({ 746, 1159, 3267, 3268, 7926, 7927, 10838, 10839, 18608, 18610, 23567, 23568, 23569, 23696, 24412, 24413, 24414, 470345 }, { duration = 8, type = "BUFF" }) -- First Aid
Spell(437327, { duration = 12, type = "BUFF" }) -- Charged Inspiration

-------------
-- RACIALS
-------------

Spell(26635, { duration = 10, type = "BUFF" }) -- Berserking
Spell(20600, { duration = 20, type = "BUFF" }) -- Perception
Spell(23234, { duration = 15, type = "BUFF" }) -- Blood Fury
Spell(20594, { duration = 8, type = "BUFF" }) -- Stoneform
Spell(7744, { duration = 5, type = "BUFF" }) -- Will of the Forsaken

-------------
-- PRIEST
-------------

Spell({ 18137, 19312, 19309, 19308, 19310, 19311, 421248 }, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Shadowguard
Spell({ 15473, 22917, 16592, 1213334 }, { duration = INFINITY, type = "BUFF" }) -- Shadowform

Spell(14751, { duration = FAKE, type = "BUFF", buffType = "Magic" }) -- Inner focus

Spell({ 1243, 1244, 1245, 2791, 10937, 10938 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Power Word: Fortitude
Spell({ 21562, 21564, 450086 }, { duration = 3600, type = "BUFF", buffType = "Magic" }) -- Prayer of Fortitude
Spell({ 976, 10957, 10958 }, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Shadow Protection
Spell(27683, { duration = 1200, type = "BUFF", buffType = "Magic" }) -- Prayer of Shadow Protection
Spell({ 14752, 14818, 14819, 27841 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Divine Spirit
Spell(27681, { duration = 3600, type = "BUFF", buffType = "Magic" }) -- Prayer of Spirit
Spell(19264, { duration = 600, type = 'BUFF', buffType = 'Magic' }) -- 'Touch of Weakness'", -- [444]
Spell({ 588, 602, 1006, 7128, 10951, 10952 }, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Inner Fire

Spell({ 14743, 27828 }, { duration = 6, type = "BUFF", buffType = "Magic" }) -- Focused Casting (Martyrdom)
Spell(27827, { duration = 10, type = "BUFF" }) -- Spirit of Redemption
Spell(15271, { duration = 15, type = "BUFF" }) -- Spirit Tap

Spell({ 13896, 19271, 19273, 19274, 19275 }, { duration = 15, type = "BUFF" }) -- Feedback
Spell({ 2651, 19289, 19291, 19292, 19293 }, { duration = 15, type = "BUFF" }) -- Elune's Grace

Spell(6346, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Fear Ward
Spell({ 14893, 15357, 15359 }, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Inspiration
Spell({ 7001, 27873, 27874 }, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Lightwell Renew
Spell(552, { duration = 20, type = "BUFF", buffType = "Magic" }) -- Abolish Disease
Spell({ 17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901, 1236154 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- PWS
Spell({ 139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315, 425268, 425269, 425270, 425271, 425272, 425273, 425274, 425275, 425276, 425277, 438341 }, {
    duration = 15,
    type = "BUFF", buffType = "Magic" }) -- Renew

Spell(10060, { duration = 15, type = "BUFF", buffType = "Magic" }) --Power Infusion
Spell({ 586, 9578, 9579, 9592, 10941, 10942 }, { duration = 10, type = "BUFF" }) -- Fade

---------------
-- DRUID
---------------

Spell(768, { duration = INFINITY, type = "BUFF" }) -- Cat Form
Spell(783, { duration = INFINITY, type = "BUFF" }) -- Travel Form
Spell(5487, { duration = INFINITY, type = "BUFF" }) -- Bear Form
Spell(9634, { duration = INFINITY, type = "BUFF" }) -- Dire Bear Form
Spell(1066, { duration = INFINITY, type = "BUFF" }) -- Aquatic Form
Spell(24858, { duration = INFINITY, type = "BUFF" }) -- Moonkin Form
Spell(469271, { duration = INFINITY, type = "BUFF" }) -- Astral Form
Spell(24907, { duration = GHOST, type = 'BUFF' }) -- 'Moonkin Aura'", -- [302]
Spell(24932, { duration = GHOST, type = "BUFF" }) -- Leader of the Pack
Spell(17116, { duration = FAKE, type = "BUFF", buffType = "Magic" }) -- Nature's Swiftness
Spell(409324, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Ancestral Guidance
Spell(417147, { duration = 30, type = "BUFF" }) -- Efflorescence

Spell({ 1126, 5232, 5234, 6756, 8907, 9884, 9885 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Mark of the Wild
Spell({ 21849, 21850 }, { duration = 3600, type = "BUFF", buffType = "Magic" }) -- Gift of the Wild
Spell(19975, { duration = 12, buffType = "Magic" }) -- Nature's Grasp root
Spell({ 16689, 16810, 16811, 16812, 16813, 17329 }, { duration = 45, type = "BUFF", buffType = "Magic" }) -- Nature's Grasp
Spell(16864, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Omen of Clarity
Spell(16870, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Clearcasting from OoC


Spell({ 467, 782, 1075, 8914, 9756, 9910 }, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Thorns
Spell({ 22812, 428713 }, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Barkskin
--SKIPPING: Hurricane (Channeled)

Spell({ 1850, 9821 }, { duration = 15, type = "BUFF" }) -- Dash
Spell(5229, { duration = 10, type = "BUFF" }) -- Enrage
Spell({ 22842, 22895, 22896, 428708 }, { duration = 10, type = "BUFF" }) -- Frenzied Regeneration
Spell({ 5217, 6793, 9845, 9846, 417045 }, { name = "Tiger's Fury", duration = 6 })
Spell(2893, { duration = 8, type = "BUFF", buffType = "Magic" }) -- Abolish Poison
Spell({ 29166, 456195 }, { duration = 20, type = "BUFF", buffType = "Magic" }) -- Innervate

Spell({ 8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858, 436937, 436946, 436943, 436939, 436945, 436942, 436938, 436940, 436944 }, { duration = 21, type = "BUFF", buffType = "Magic" }) -- Regrowth

Spell({ 774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299, 417061, 417064, 417063, 417057, 417062, 417059, 417058, 417066, 417068, 417060, 417065 }, {
    duration = 12, type = "BUFF", buffType = "Magic" }) -- Rejuv

-------------
-- WARRIOR
-------------

Spell(2457, { duration = INFINITY, type = "BUFF" }) -- Battle Stance
Spell(2458, { duration = INFINITY, type = "BUFF" }) -- Berserker Stance
Spell(71, { duration = INFINITY, type = "BUFF" }) -- Def Stance
Spell(412513, { duration = INFINITY, type = "BUFF" }) -- Gladiator Stance

Spell(20230, { duration = 15, type = "BUFF" }) -- Retaliation
Spell(1719, { duration = 15, type = "BUFF" }) -- Recklessness
Spell(871, { type = "BUFF", duration = 10 }) -- Shield wall, varies
Spell(12976, { duration = 20, type = "BUFF" }) -- Last Stand

Spell({ 5242, 6192, 6673, 11549, 11550, 11551, 25289 }, { type = "BUFF",
                                                          duration = 120 }) -- Battle Shout
Spell(403215, { duration = 120, type = "BUFF" }) -- Commanding Shout


Spell(18499, { duration = 10, type = "BUFF" }) -- Berserker Rage

Spell(29131, { duration = 10, type = "BUFF" }) -- Bloodrage
Spell(2565, { duration = 5, type = "BUFF" }) -- Shield Block, varies BUFF
Spell(12292, { duration = 20, type = "BUFF" }) -- Sweeping Strikes
Spell({ 12880, 14201, 14202, 14203, 14204 }, { duration = 12, type = "BUFF" }) -- Enrage
Spell({ 12966, 12967, 12968, 12969, 12970 }, { duration = 15, type = "BUFF" }) -- Flurry
Spell({ 16488, 16490, 16491 }, { duration = 6, type = "BUFF" }) -- Blood Craze
Spell({ 23885, 23886, 23887, 23888 }, { duration = 6, type = "BUFF" }) -- Bloodthirst

--------------
-- ROGUE
--------------

Spell(14177, { duration = FAKE, type = "BUFF" }) -- Cold Blood
Spell({ 1784, 1785, 1786, 1787, 450667, 420536 }, { duration = GHOST, type = "BUFF" }) -- Stealth

Spell(14278, { duration = 7, type = "BUFF" }) -- Ghostly Strike
Spell(13750, { duration = 15, type = "BUFF" }) -- Adrenaline Rush
Spell(13877, { duration = 15, type = "BUFF" }) -- Blade Flurry
Spell({ 5171, 6774 }, { duration = nil, type = "BUFF" }) -- SnD, to prevent fallback to incorrect db values
Spell({ 2983, 8696, 11305 }, { duration = 15, type = "BUFF" }) -- Sprint
Spell(5277, { duration = 15, type = "BUFF" }) -- Evasion

------------
-- WARLOCK
------------

Spell({ 20707, 20762, 20763, 20764, 20765 }, { duration = 1800, type = "BUFF" }) -- Soulstone Resurrection
Spell({ 687, 696 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Demon Skin
Spell({ 706, 1086, 11733, 11734, 11735 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Demon Armor
Spell({ 18791 }, { duration = 1800, type = "BUFF", })  -- Touch of Shadow
Spell({ 18789 }, { duration = 1800, type = "BUFF", })  -- Burning Wish
Spell({ 18792 }, { duration = 1800, type = "BUFF", })  -- Fel Energy
Spell({ 18790 }, { duration = 1800, type = "BUFF", })  -- Fel Stamina
Spell({ 430025, 425463 }, { duration = 6, type = "BUFF" }) -- Demonic Grace
Spell(425467, { duration = 45, type = "BUFF", buffType = "Magic" }) -- Demonic Pact
Spell(427713, { duration = 10, type = "BUFF" }) -- Backdraft
Spell({ 18288 }, { duration = 1800, type = "BUFF", buffType = "Magic" })  -- Amplify Curse
Spell({ 6307, 7804, 7805, 11766, 11767 }, { duration = GHOST }) -- Blood Pact
Spell({ 18708 }, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Fel Domination
Spell({ 19480 }, { duration = FAKE }) -- Paranoia
Spell({ 25228 }, { duration = FAKE, type = "BUFF", buffType = "Magic" }) -- Soul Link
Spell({ 23829 }, { duration = INFINITY, type = "BUFF" }) -- Master Demonologist
Spell({ 6229, 11739, 11740, 28610 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Shadow Ward
Spell({ 7812, 19438, 19440, 19441, 19442, 19443 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Sacrifice

---------------
-- SHAMAN
---------------

Spell({ 8185, 10534, 10535 }, { duration = 120, type = "BUFF" }) -- Fire Resistance Totem
Spell({ 8182, 10476, 10477 }, { duration = 120, type = "BUFF" }) -- Frost Resistance Totem
Spell({ 10596, 10598, 10599 }, { duration = 120, type = "BUFF" }) -- Nature Resistance Totem
Spell(25909, { duration = 120, type = "BUFF" }) -- Tranquil Air Totem
Spell({ 5672, 6371, 6372, 10460, 10461 }, { duration = 60, type = "BUFF" }) -- Healing Stream Totem
Spell({ 5677, 10491, 10493, 10494 }, { duration = 60, type = "BUFF" }) -- Mana Spring Totem
Spell({ 8076, 8162, 8163, 10441, 25362 }, { duration = 120, type = "BUFF" }) -- Strength of Earth Totem
Spell({ 8836, 10626, 25360 }, { duration = 120, type = "BUFF" }) -- Grace of Air Totem
Spell({ 8072, 8156, 8157, 10403, 10404, 10405 }, { duration = 120, type = "BUFF" }) -- Stoneskin Totem
Spell({ 16191, 17355, 17360 }, { duration = 12, type = "BUFF" }) -- Mana Tide Totem
Spell(16166, { duration = FAKE, type = "BUFF" }) -- Elemental Mastery

Spell(8178, { duration = 45, type = "BUFF" }) -- Grounding Totem Effect, no duration, but lasts 45s. Keeping for enemy buffs
Spell({ 324, 325, 905, 945, 8134, 10431, 10432 }, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Lightning Shield
Spell(546, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Water Walking
Spell(131, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Water Breahing
Spell(408510, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Water Shield
Spell({ 16257, 16277, 16278, 16279, 16280 }, { duration = 15, type = "BUFF" }) -- Flurry

Spell({ 16177, 16236, 16237 }, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Ancestral Fortitude from Ancestral Healing
Spell(29203, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Healing Way
Spell({ 27689, 16170, 6742, 24185, 21049 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Bloodlust



--------------
-- PALADIN
--------------

Spell(19746, { duration = INFINITY, type = "BUFF" }) -- Concentration Aura
Spell({ 465, 643, 1032, 10290, 10291, 10292, 10293 }, { duration = INFINITY, type = "BUFF" }) -- Devotion Aura
Spell({ 19891, 19899, 19900 }, { duration = INFINITY, type = "BUFF" }) -- Fire Resistance Aura
Spell({ 19888, 19897, 19898 }, { duration = INFINITY, type = "BUFF" }) -- Frost Resistance Aura
Spell({ 19876, 19895, 19896 }, { duration = INFINITY, type = "BUFF" }) -- Shadow Resistance Aura
Spell({ 7294, 10298, 10299, 10300, 10301 }, { duration = INFINITY, type = "BUFF" }) -- Retribution Aura
Spell({ 20218 }, { duration = INFINITY, type = "BUFF" }) -- Sanctity Aura


Spell(25780, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Righteous Fury

Spell({ 19740, 19834, 19835, 19836, 19837, 19838, 25291 }, { duration = 300, type = "BUFF", buffType = "Magic" }) -- Blessing of Might
Spell({ 25782, 25916 }, { duration = 900, type = "BUFF", buffType = "Magic" }) -- Greater Blessing of Might

Spell({ 19742, 19850, 19852, 19853, 19854, 25290 }, { duration = 300, type = "BUFF", buffType = "Magic" }) -- Blessing of Wisdom
Spell({ 25894, 25918 }, { duration = 900, type = "BUFF", buffType = "Magic" }) -- Greater Blessing of Might

Spell(20217, { duration = 300, type = "BUFF", buffType = "Magic" }) -- Blessing of Kings
Spell(25898, { duration = 900, type = "BUFF", buffType = "Magic" }) -- Greater Blessing of Kings

Spell({ 20911, 20912, 20913 }, { duration = 300, type = "BUFF", buffType = "Magic" }) -- Blessing of Sanctuary
Spell(25899, { duration = 900, type = "BUFF", buffType = "Magic" }) -- Greater Blessing of Sanctuary

Spell(1038, { duration = 300, type = "BUFF", buffType = "Magic" }) -- Blessing of Salvation
Spell(25895, { duration = 900, type = "BUFF", buffType = "Magic" }) -- Greater Blessing of Salvation

Spell({ 19977, 19978, 19979 }, { duration = 300, type = "BUFF", buffType = "Magic" }) -- Blessing of Light
Spell(25890, { duration = 900, type = "BUFF", buffType = "Magic" }) -- Greater Blessing of Light


Spell(1044, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Blessing of Freedom
Spell({ 6940, 20729 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Blessing of Sacrifice
Spell({ 1022, 5599, 10278 }, { type = "BUFF",
                               buffType = "Magic",
                               duration = function(spellID)
                                   if spellID == 1022 then
                                       return 6
                                   elseif spellID == 5599 then
                                       return 8
                                   else
                                       return 10
                                   end
                               end
}) -- Blessing of Protection
Spell({ 498, 5573, 442948 }, { type = "BUFF",
                               duration = function(spellID)
                                   return (spellID == 498 and 6) or (spellID == 442948 and 10) or 8
                               end
}) -- Divine Protection
Spell({ 642, 1020 }, { type = "BUFF",
                       duration = function(spellID)
                           return spellID == 642 and 10 or 12
                       end
}) -- Divine Shield
Spell({ 20375, 20915, 20918, 20919, 20920 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Seal of Command
Spell({ 21084, 20287, 20288, 20289, 20290, 20291, 20292, 20293, 20154 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Seal of Righteousness
Spell({ 20162, 20305, 20306, 20307, 20308, 21082 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Seal of the Crusader
Spell({ 20165, 20347, 20348, 20349 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Seal of Light
Spell({ 20166, 20356, 20357 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Seal of Wisdom
Spell(20164, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Seal of Justice
Spell({ 20925, 20927, 20928 }, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Holy Shield
Spell({ 20128, 20131, 20132, 20133, 20134 }, { duration = 10, type = "BUFF" }) -- Redoubt
Spell({ 67, 26017, 26018 }, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Vindication
Spell({ 20050, 20052, 20053, 20054, 20055 }, { duration = 8, type = "BUFF", buffType = "Magic" }) -- Vengeance
Spell({ 16431, 11445 }, { duration = 60, type = "BUFF", buffType = "Magic" }) -- Bone Armor

-------------
-- HUNTER
-------------
Spell(469145, { duration = FAKE, type = "BUFF" }) -- Aspect of the Falcon
Spell(13161, { duration = FAKE, type = "BUFF" }) -- Aspect of the Beast
Spell(5118, { duration = FAKE, type = "BUFF" }) -- Aspect of the Cheetah
Spell(13159, { duration = FAKE, type = "BUFF" }) -- Aspect of the Pack
Spell(13163, { duration = FAKE, type = "BUFF" }) -- Aspect of the Monkey
Spell(415423, { duration = FAKE, type = "BUFF" }) -- Aspect of the Viper
Spell({ 20043, 20190 }, { duration = FAKE, type = "BUFF" }) -- Aspect of the Wild
Spell({ 13165, 14318, 14319, 14320, 14321, 14322, 25296 }, { duration = FAKE, type = "BUFF" }) -- Aspect of the Hawk
Spell(409580, { duration = INFINITY, type = "BUFF" }) -- Heart of the Lion
Spell(5384, { duration = 360, type = "BUFF" }) -- Feign Death (Will it work?)
Spell(415320, { duration = 10, type = "BUFF" }) -- Flanking Strike

Spell({ 19506, 20905, 20906 }, { duration = 1800, type = "BUFF", }) -- Trueshot Aura
Spell(19615, { duration = 8, type = "BUFF" }) -- Frenzy
Spell({ 1130, 14323, 14324, 14325 }, { duration = 120 }) -- Hunter's Mark
Spell(19263, { duration = 10, type = "BUFF" }) -- Deterrence
Spell(3045, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Rapid Fire
Spell(19574, { duration = 18, type = "BUFF" }) -- Bestial Wrath
Spell({ 136, 3111, 3661, 3662, 13542, 13543, 13544 }, { duration = 5, type = "BUFF" }) -- Mend Pet

-------------
-- MAGE
-------------

Spell(12043, { duration = FAKE, type = "BUFF", buffType = "Magic" }) -- Presence of Mind

Spell({ 1459, 1460, 1461, 10156, 10157 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Arcane Intellect
Spell(23028, { duration = 3600, type = "BUFF", buffType = "Magic" }) -- Arcane Brilliance
Spell({ 6117, 22782, 22783 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Mage Armor
Spell({ 168, 7300, 7301, 12544 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Frost Armor
Spell({ 7302, 7320, 10219, 10220 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Ice Armor
Spell(2855, { duration = 120, type = "BUFF", buffType = "Magic" }) -- Detect Magic
Spell(130, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Slow Fall
Spell({ 604, 8450, 8451, 10173, 10174 }, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Dampen Magic
Spell({ 1008, 8455, 10169, 10170 }, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Amplify Magic
Spell(11958, { duration = 10, type = "BUFF" }) -- Ice Block
Spell({ 1463, 8494, 8495, 10191, 10192, 10193, 412120, 412121, 412123, 412116, 412122, 412118, 17741, 17740 }, { duration = 60, type = "BUFF", buffType = "Magic" }) -- Mana Shield
Spell({ 11426, 13031, 13032, 13033, 1213278 }, { duration = 60, type = "BUFF", buffType = "Magic" }) -- Ice Barrier
Spell({ 543, 8457, 8458, 10223, 10225, 412218, 412231, 412230, 412214, 412232 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Fire Ward
Spell({ 6143, 8461, 8462, 10177, 28609, 412207, 412205, 412209, 412210, 412202 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Frost Ward

-- SoD
Spell(443369, { duration = 20, type = "BUFF" }) -- Chrono Preserv
Spell(400735, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Temporal Beacon
Spell(431655, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Mind Spike
Spell({ 426316, 426311 }, { duration = 10, type = "BUFF" }) -- Shadow and flame
Spell(426490, { duration = 10, type = "BUFF" }) -- Rallying cry
Spell(426158, { duration = 12, type = "BUFF" }) -- Sheath of Light
Spell(438040, { duration = 15, type = "BUFF" }) -- Redirect
Spell({ 433255, 425336 }, { duration = 15, type = "BUFF" }) -- Shamanistic Rage
Spell({ 425874, 425876, 436391 }, { duration = 10, type = "BUFF" }) -- Decoy Totem
Spell({ 427725, 427726, 469357 }, { duration = FAKE, type = "BUFF" }) -- Immolation Aura
Spell({ 412019, 53601 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Sacred Shield
Spell({ 412018, 58597 }, { duration = 6, type = "BUFF", buffType = "Magic" }) -- Sacred Shield
Spell({ 408255, 408250 }, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Eclipse
Spell({ 429125, 425121 }, { duration = 20, type = "BUFF", buffType = "Magic" }) -- Icy Veins
Spell(442211, { duration = 30, type = "BUFF" }) -- Berserk
Spell(417141, { duration = 15, type = "BUFF" }) -- Berserk
Spell(426979, { duration = 5, type = "BUFF" }) -- Sword & Board
Spell(413399, { duration = 15, type = "BUFF" }) -- Blood surge
Spell(428878, { duration = 30, type = "BUFF" }) -- Balefire Bolt
Spell({ 429307, 428741 }, { duration = 1800, type = "BUFF" }) -- Molten Armor
Spell({ 426940, 427070, 426942 }, { duration = 30, type = "BUFF" }) -- Rampage
Spell({ 426969, 426953 }, { duration = 9, type = "BUFF" }) -- Taste for Blood
Spell({ 431624, 431649 }, { duration = 12, type = "BUFF", buffType = "Magic" }) -- Divine Aegis
Spell(425585, { duration = 10, type = "BUFF" }) -- Aegis
Spell(427065, { duration = 12, type = "BUFF" }) -- Wrecking Crew
Spell({ 428912, 429243, 428909 }, { duration = 15, type = "BUFF" }) -- Light's Grace
Spell({ 426972, 427068 }, { duration = 1800, type = "BUFF" }) -- Vigilance
Spell(431666, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Surge of Light
Spell(425294, { duration = 6, type = "BUFF" }) -- Dispersion
Spell({ 400624, 48108, 400625 }, { duration = 10, type = "BUFF" }) -- Hot Streak
Spell(408261, { duration = 8, type = "BUFF" }) -- Dreamstate
Spell(407798, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Seal of Martyrdom
Spell({ 400589, 400588 }, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Missile Barrage
Spell(402004, { duration = 8, type = "BUFF", buffType = "Magic" }) -- Pain Suppression
Spell(425124, { duration = 8, type = "BUFF" }) -- Arcane Surge
Spell(408124, { duration = 7, type = "BUFF", buffType = "Magic" }) -- Lifebloom
Spell({ 402913, 403359 }, { duration = 10, type = "BUFF" }) -- Enraged Regen
Spell(400730, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Fireball!
Spell({ 400669, 400670 }, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Fingers of Frost
Spell(406722, { duration = 3, type = "BUFF" }) -- Shadowstep
Spell({ 425096, 425098 }, { duration = 6, type = "BUFF" }) -- MoS
Spell(407613, { duration = 3600, type = "BUFF", buffType = "Magic" }) -- Beacon of Light
Spell(403338, { duration = 10, type = "BUFF" }) -- Intervene
Spell({ 408514, 974 }, { duration = 600, type = "BUFF", buffType = "Magic" }) -- Earth Shield
Spell(408120, { duration = 6, type = "BUFF", buffType = "Magic" }) -- Wild Growth
Spell({ 401859, 401877 }, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Prayer of Mending
Spell(407804, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Divine Sacrifice
Spell(407988, { duration = 34, type = "BUFF", buffType = "" }) -- Savage Roar
Spell({ 425207, 425205 }, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Power Word Barrier
Spell(401990, { duration = 5, type = "BUFF" }) -- ShadowCrawl
Spell(414800, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Fury of Stormrage
Spell(413247, { duration = 20, type = "BUFF", buffType = "Magic" }) -- Serendipity
Spell(417157, { duration = 15, type = "BUFF" }) -- Starsurge
Spell(53489, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Art of War
Spell(408024, { duration = 20, type = "BUFF" }) -- Survival Instincts
Spell({ 430949, 430952, 430950, 430951, 430948 }, { duration = 1800, type = "BUFF", buffType = "Magic" }) --  Arcane buffs
Spell(12043, { duration = 15, type = "BUFF" }) -- Presence of Mind
Spell(12042, { duration = 15, type = "BUFF" }) -- Arcane Power
Spell(12051, { duration = 8, type = "BUFF" }) -- Evocation
Spell(402906, { duration = 12, type = "BUFF" }) -- Flagellation (Warrior)
Spell({ 442226, 442226, 442233, 403828 }, { duration = 3, type = "BUFF" }) -- Menace (Warlock)
Spell({ 400573, 400586 }, { duration = 6, type = "BUFF" }) -- Arcane Blast
Spell(435978, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Energized Hyperconductor
Spell(403789, { duration = INFINITY, type = "BUFF" }) -- Metamorphosis
Spell(426301, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Grimoire of Synergy
Spell(426303, { duration = 15, type = 'BUFF' }) -- 'Grimoire of Synergy'", -- [574]
Spell(408696, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Spirit of the Alpha
Spell(408953, { duration = INFINITY, type = "BUFF" }) -- Building Inspiration
Spell({ 415233, 2645 }, { duration = INFINITY, type = "BUFF", buffType = "Magic" }) -- Ghost Wolf
Spell(415292, { duration = 12, type = "BUFF", buffType = "Magic" }) -- Earthliving
Spell(409324, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Ancestral Guidance
Spell(408505, { duration = 30, type = "BUFF", buffType = "Magic" }) -- Maelstrom Weapon
Spell(415236, { duration = 10, type = "BUFF" }) -- Healing Rain
Spell(425284, { duration = 10, type = "BUFF" }) -- Spirit of the Redeemer
Spell(407805, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Sacrifice Redeemed
Spell(415058, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Guarded by the Light
Spell(407804, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Divine Sacrifice
Spell(401460, { duration = 1.5, type = "BUFF", buffType = "Magic" }) -- Rapid Regeneration
Spell(412510, { duration = 3, type = "BUFF", buffType = "Magic" }) -- Mass Regeneration
Spell(409583, { duration = 15, type = "BUFF" }) -- Heart of the Lion
Spell(428728, { duration = 10, type = "BUFF" }) -- Frenzy
Spell({ 438536, 438537 }, { duration = 7200, type = "BUFF" }) -- Spark of Inspiration
Spell({ 430947, 431111 }, { duration = 7200, type = "BUFF" }) -- Boon of Blackfathom
Spell(429959, { duration = 7200, type = "BUFF" }) -- Well Rested
Spell(435973, { duration = 20, type = "BUFF" }) -- Mildly Irradiated
Spell(439155, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Sigil of Innovation
Spell({ 437698, 437699 }, { duration = 30, type = "BUFF" }) -- Coin Flip
Spell(437357, { duration = 20, type = "BUFF" }) -- Gneuromantic Meditation
Spell(434488, { duration = 30, type = "BUFF" }) -- Spicy!
Spell(436443, { duration = 6, type = "BUFF" }) -- Command Aura
Spell(430948, { duration = 1800, type = "BUFF", buffType = "Magic" }) -- Arcane Recovery
Spell(437362, { duration = 10, type = "BUFF" }) -- Hyperconductive Shock
Spell(435899, { duration = 20, type = "BUFF" }) -- Gyroscopic Acceleration
Spell(437382, { duration = 10, type = "BUFF" }) -- Reinforced Willpower
Spell(435895, { duration = 5, type = "BUFF" }) -- Gniodine Dispel
Spell(400015, { duration = 30, type = "BUFF" }) -- Rolling with the Punches
Spell(428489, { duration = 6, type = "BUFF" }) -- Planar Shift
Spell(415105, { duration = 10, type = "BUFF", buffType = "Magic" }) -- Power surge
Spell(436373, { duration = 20, type = "BUFF" }) -- Sanguine Sanctuary
Spell(407627, { duration = INFINITY, type = "BUFF", buffType = "Magic" }) -- Righteous Fury
Spell(435168, { duration = 1800, type = "BUFF" }) -- Guard of the Innovator
Spell(428895, { duration = 15, type = "BUFF" }) -- Temporal Anomaly
Spell(415320, { duration = 10, type = "BUFF" }) -- Flanking Strike
Spell(409396, { duration = 30, type = "BUFF" }) -- Kill Command
Spell(432041, { duration = 20, type = "BUFF", buffType = "Magic" }) -- Tidal Waves
Spell(425714, { duration = 30, type = "BUFF" }) -- Cobra Strikes
Spell(436376, { duration = 20, type = "BUFF" }) -- Chain Heal Cost Reduced
Spell({ 412325, 412326 }, { duration = 10, type = "BUFF" }) -- Enlightenment
Spell(436412, { duration = INFINITY, type = "BUFF" }) -- Discoverer's Delight
Spell(407631, { duration = 3, type = "BUFF" }) -- Discoverer's Delight
Spell(437349, { duration = 10, type = "BUFF" }) -- Gneuro-Logical Shock
Spell(429867, { duration = 10, type = "BUFF" }) -- Void Madness
Spell(436100, { duration = 8, type = "BUFF", buffType = "Magic" }) -- Petrify
Spell(437377, { duration = 20, type = "BUFF" }) -- Intense Concentration
Spell(400012, { duration = 30, type = "BUFF" }) -- Blade Dance
Spell(425600, { duration = 120, type = "BUFF" }) -- Horn of Lordaeron
Spell(428726, { duration = 20, type = "BUFF" }) -- Focus Fire
Spell(407880, { duration = 120, type = "BUFF", buffType = "Magic" }) -- Inspiration Exemplar
Spell(409507, { duration = 7, type = "BUFF", buffType = "Magic" }) -- Expose Weakness
Spell(414680, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Living Seed
Spell(426162, { duration = 12, type = "BUFF", buffType = "Magic" }) -- Sheath of Light (HoT)
Spell(426159, { duration = 60, type = "BUFF" }) -- Sheath of Light
Spell(435359, { duration = 10, type = "BUFF" }) -- Hardened to the Core
Spell(436469, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Bloodlash
Spell(434851, { duration = 4, type = "BUFF" }) -- Minor Evocation
Spell(436430, { duration = 15, type = "BUFF" }) -- Avenging Wrath
Spell(412020, { duration = 12, type = "BUFF", buffType = "Magic" }) -- Flash of Light
Spell(408525, { duration = 15, type = "BUFF" }) -- Shield Mastery
Spell(436387, { duration = 7200, type = "BUFF" }) -- Blessing of the Blood Loa
Spell(433797, { duration = 7, type = "BUFF" }) -- Bladestorm
Spell(408309, { duration = 30, type = "BUFF" }) -- Grace of Elune
Spell(398198, { duration = 30, type = "BUFF" }) -- Storm of Swords
Spell(408307, { duration = 30, type = "BUFF" }) -- Nature's Fury
Spell(420667, { duration = INFINITY, type = "BUFF" }) -- Horde Warbanner
Spell(423298, { duration = 20, type = "BUFF" }) -- Swimming Speed Minor
Spell(437716, { duration = 2, type = "BUFF" }) -- Primal Bloodthirst
Spell(400024, { duration = 3, type = "BUFF" }) -- Cheating Death
Spell(407791, { duration = 15, type = "BUFF", buffType = "" }) -- Aku'mai's Rage
Spell(430494, { duration = 300, type = "BUFF" }) -- WoW Variety Show - Blazing Speed!
Spell(430492, { duration = 300, type = "BUFF" }) -- WoW Variety Show - Healthy Competition!
Spell(434907, { duration = 15, type = "BUFF" }) -- Amplified Circuitry
Spell(427714, { duration = 10, type = "BUFF" }) -- Backdraft
--Spell(436351, {duration = INFINITY, type = 'BUFF'}) -- 'Zandalari Ward'"
Spell(2479, { duration = 30, type = 'BUFF' }) -- 'Honorless Target'"
Spell({ 6783, 5215, 9913 }, { duration = GHOST, type = 'BUFF' }) -- 'Prowl'", -- [298]
Spell(16886, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- 'Nature's Grace'", -- [305]
Spell(436378, { duration = 4, type = 'BUFF' }) -- 'Tigerblood Talisman'", -- [310]
Spell(23109, { duration = 15, type = 'BUFF' }) -- 'Dash'", -- [312]
Spell(20580, { duration = GHOST, type = 'BUFF' }) -- 'Shadowmeld'", -- [315]
Spell(8100, { duration = 1800, type = 'BUFF', buffType = 'Magic' }) -- 'Stamina'", -- [317]
Spell(1953, { duration = 1, type = 'BUFF' }) -- 'Blink'", -- [322]
Spell({ 407975, 433107 }, { duration = INFINITY, type = 'BUFF' }) -- 'Wild Strikes'", -- [325]
Spell(9632, { duration = 9, type = 'BUFF' }) -- 'Bladestorm'", -- [336]
Spell({ 11327, 1856, 1857, 11329 }, { duration = GHOST, type = 'BUFF' }) -- 'Vanish'", -- [344]
Spell(3593, { duration = 3600, type = 'BUFF' }) -- 'Health II'", -- [358]
Spell(1133, { duration = 27, type = 'BUFF' }) -- 'Drink'", -- [359]
Spell(412735, { duration = INFINITY, type = 'BUFF' }) -- 'Demonic Knowledge'", -- [365]
Spell(8599, { duration = 120, type = 'BUFF' }) -- 'Enrage'", -- [368]
Spell(17680, { duration = 60, type = 'BUFF' }) -- 'Spirit Spawn-out'", -- [371]
Spell({ 12536, 16246, 467735 }, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- 'Clearcasting'", -- [378]
Spell({ 401417, 456485 }, { duration = 3, type = 'BUFF', buffType = 'Magic' }) -- 'Regeneration'", -- [383]
Spell(435117, { duration = 30, type = 'BUFF' }) -- 'Meditation on the Abyss'", -- [385]
Spell(3149, { duration = 15, type = 'BUFF' }) -- 'Furious Howl'", -- [721]
Spell(436365, { duration = 10, type = 'BUFF' }) -- 'Two-Handed Mastery'", -- [720]
Spell(3229, { duration = 5, type = 'BUFF', buffType = 'Magic' }) -- 'Quick Bloodlust'", -- [716]
Spell(6268, { duration = 3, type = 'BUFF' }) -- 'Rushing Charge'", -- [715]
Spell(24603, { duration = 10, type = 'BUFF' }) -- 'Furious Howl'", -- [712]
Spell(430432, { duration = INFINITY, type = 'BUFF' }) -- 'Battle Hardened'", -- [638]
Spell(20236, { duration = 120, type = 'BUFF', buffType = 'Magic' }) -- 'Lay on Hands'", -- [637]
Spell(11350, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- 'Fire Shield'", -- [631]
Spell(301091, { duration = INFINITY, type = 'BUFF' }) -- 'Alliance Flag'", -- [630]
Spell(301089, { duration = INFINITY, type = 'BUFF' }) -- 'Horde Flag'", -- [625]
Spell(20216, { duration = FAKE, type = 'BUFF', buffType = 'Magic' }) -- 'Divine Favor'", -- [624]
Spell(436741, { duration = 15, type = 'BUFF' }) -- 'Overheat'", -- [608]
Spell(436825, { duration = 15, type = 'BUFF' }) -- 'Frayed Wiring'", -- [607]
Spell(436816, { duration = 5, type = 'BUFF' }) -- 'Sprocketfire Breath'", -- [606]
Spell(436739, { duration = 15, type = 'BUFF' }) -- 'Cluck!'", -- [604]
Spell(8212, { duration = 120, type = 'BUFF' }) -- 'Enlarge'", -- [603]
Spell(25722, { duration = 900, type = 'BUFF' }) -- 'Rumsey Rum Dark'", -- [602]
Spell(8220, { duration = 3600, type = 'BUFF' }) -- 'Flip Out'", -- [597]
Spell(433813, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- 'Neverending Soul Vessel'", -- [596]
Spell(412800, { duration = 15, type = 'BUFF' }) -- 'Dance of the Wicked'", -- [592]
Spell(10732, { duration = 10, type = 'BUFF' }) -- 'Supercharge'", -- [590]
Spell(1539, { duration = 20, type = 'BUFF' }) -- 'Feed Pet Effect'", -- [589]
Spell(23768, { duration = 7200, type = 'BUFF' }) -- 'Sayge's Dark Fortune of Damage'", -- [586]
Spell(436074, { duration = 10, type = 'BUFF' }) -- 'Trogg Rage'", -- [584]
Spell(13494, { duration = 30, type = 'BUFF' }) -- 'Haste'", -- [582]
Spell(3019, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- 'Enrage'", -- [576]
Spell(15852, { duration = 600, type = 'BUFF', buffType = 'Poison' }) -- 'Dragonbreath Chili'", -- [573]
Spell(19710, { duration = 900, type = 'BUFF' }) -- 'Well Fed'", -- [570]
Spell(23738, { duration = 7200, type = 'BUFF' }) -- 'Sayge's Dark Fortune of Spirit'", -- [567]
Spell(399963, { duration = 6, type = 'BUFF', buffType = 'Poison' }) -- 'Envenom'", -- [394]
Spell(15062, { duration = 10, type = 'BUFF' }) -- 'Shield Wall'", -- [396]
Spell(408680, { duration = 10, type = 'BUFF' }) -- 'Way of Earth'", -- [402]
Spell(6150, { duration = 12, type = 'BUFF' }) -- 'Quick Shots'", -- [403]
Spell(8095, { duration = 1800, type = 'BUFF', buffType = 'Magic' }) -- 'Armor'", -- [415]
Spell(436471, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- 'Bloodlash'", -- [473]
Spell(14149, { duration = 20, type = 'BUFF' }) -- 'Remorseless'", -- [493]
Spell(438541, { duration = 1, type = 'BUFF' }) -- 'Charge'", -- [494]
Spell(412758, { duration = 15, type = 'BUFF' }) -- 'Incinerate'", -- [495]
Spell(17941, { duration = 10, type = 'BUFF', buffType = 'Magic' }) -- 'Shadow Trance'", -- [497]
Spell(28682, { duration = FAKE, type = 'BUFF', buffType = 'Magic' }) -- 'Combustion'", -- [505]
Spell(8317, { duration = 180, type = 'BUFF', buffType = 'Magic' }) -- 'Fire Shield'", -- [506]
Spell(436482, { duration = 20, type = 'BUFF' }) -- 'Bloodbark Cleave'", -- [515]
Spell(436374, { duration = 4, type = 'BUFF' }) -- 'Infernal Pact'", -- [521]
Spell(3164, { duration = 3600, type = 'BUFF' }) -- 'Strength'", -- [537]
Spell(11328, { duration = 3600, type = 'BUFF' }) -- 'Agility'", -- [538]
Spell(437585, { duration = 60, type = 'BUFF' }) -- 'Pillars of Might'
Spell(437410, { duration = 20, type = 'BUFF' }) -- 'Deep Slumber'
Spell({ 415140, 415144 }, { duration = 10, type = 'BUFF' }) -- 'Mental Dexterity'
Spell(415362, { duration = 15, type = 'BUFF', buffType = '' }) -- Raptor Fury
Spell(426195, { duration = 20, type = 'BUFF' }) -- Vengeance
Spell(402789, { duration = 30, type = 'BUFF' }) -- Eye of the Void
Spell(408521, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Riptide
Spell(415407, { duration = 20, type = 'BUFF' }) -- Rapid Killing
Spell(432041, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Tidal Waves
Spell(435112, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Vengeance
Spell(437877, { duration = INFINITY, type = 'BUFF' }) -- Infusion of Light
Spell(437881, { duration = INFINITY, type = 'BUFF' }) -- Infusion of Shadow
Spell(437930, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- PWS
Spell(438294, { duration = 60, type = 'BUFF', buffType = 'Magic' }) -- Thorns
Spell(440675, { duration = 8, type = 'BUFF', buffType = 'Magic' }) -- Righteous Vengeance
Spell(440668, { duration = 30, type = 'BUFF', buffType = 'Magic' }) -- Vindicator
Spell(440882, { duration = 10, type = 'BUFF', buffType = 'Magic' }) -- Infernal Armor
Spell({ 445181, 446580, 446581, 446582 }, { duration = 1200, type = 'BUFF', buffType = 'Magic' }) -- Murky Sapta Sight
Spell(446088, { duration = 3600, type = 'BUFF' }) -- Leyline Attunement
Spell({ 446219, 446231 }, { duration = 12, type = 'BUFF' }) -- Cries of Corrupted Ancestry, Serpent's Ascension
Spell(446240, { duration = 1800, type = 'BUFF', buffType = 'Magic' }) -- Sigil of Living Dreams
Spell({ 446256, 446336, 446396 }, { duration = 7200, type = 'BUFF' }) -- Atal'ai Mojo of Forbidden Magic / War / Life
Spell(446228, { duration = 3600, type = 'BUFF' }) -- Nightmarish Power
Spell(446288, { duration = 10, type = 'BUFF' }) -- Elune's Favor
Spell({ 446289, 446297, 446310 }, { duration = 20, type = 'BUFF' }) -- Relentless Strength etc
Spell(446322, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Emerald Shroud
Spell(446327, { duration = 15, type = 'BUFF' }) -- Enrage
Spell(446335, { duration = 10, type = 'BUFF' }) -- Voodoo Frenzy
Spell(446356, { duration = 6, type = 'BUFF' }) -- Improved Blocking
Spell(446382, { duration = 15, type = 'BUFF' }) -- Attuned to the Void
Spell(446397, { duration = 60, type = 'BUFF' }) -- Rainbow Generator
Spell({ 446528, 446541, 446572, 446577, 446597, 446618, 446630 }, { duration = 10, type = 'BUFF' }) -- Echoes
Spell(446586, { duration = 3, type = 'BUFF' }) -- Dizzying Spin
Spell(446687, { duration = 20, type = 'BUFF' }) -- Anguish of the Dream
Spell({ 446695, 446698, }, { duration = 7200, type = 'BUFF' }) -- Fervor of the Temple Explorer
Spell(446709, { duration = 20, type = 'BUFF' }) -- Roar of the Guardian
Spell({ 446710, 446712 }, { duration = 15, type = 'BUFF' }) -- Roar of the Grove
Spell(446722, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Call of the Arena
Spell(446729, { duration = 10, type = 'BUFF' }) -- Troll Speed
Spell(446733, { duration = 10, type = 'BUFF' }) -- Sleepwalk
Spell(446888, { duration = INFINITY, type = 'BUFF' }) -- Totem Challenge
Spell(446912, { duration = 2.5, type = 'BUFF' }) -- Dreamscape
Spell(447549, { duration = 35, type = 'BUFF', buffType = 'Magic' }) -- Feedback
Spell(448572, { duration = 30, type = 'BUFF', buffType = 'Magic' }) -- Sleep
Spell(448686, { duration = 20, type = 'BUFF' }) -- Zila Gular
Spell(448828, { duration = 6, type = 'BUFF' }) -- Overdrive
Spell(449923, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Benevolence
Spell(449925, { duration = 10, type = 'BUFF' }) -- Power Shredder
Spell(449932, { duration = 20, type = 'BUFF' }) -- Fiery Strength
Spell(449934, { duration = 10, type = 'BUFF', buffType = 'Magic' }) -- The Furious Storm
Spell(449975, { duration = 6, type = 'BUFF' }) -- Stalwart Block
Spell(449982, { duration = 10, type = 'BUFF' }) -- For Lordaeron!!
Spell(450013, { duration = 12, type = 'BUFF' }) -- Shadow Spark
Spell(448614, { duration = 300, type = 'BUFF' }) -- Bargain Bush
Spell(446706, { duration = 10, type = 'BUFF' }) -- Roar of the Dream
Spell(450658, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Renew
Spell(450654, { duration = 30, type = 'BUFF', buffType = 'Magic' }) -- Shadow Shield
Spell(450084, { duration = 15, type = 'BUFF' }) -- Rapid Cutting
Spell(448084, { duration = 3600, type = 'BUFF' }) -- Restless Dreams
Spell(437791, { duration = INFINITY, type = 'BUFF' }) -- Ritual Leader
Spell(425418, { duration = 12, type = 'BUFF' }) -- Consumed By Rage
Spell({ 407624, 416863 }, { duration = 6, type = 'BUFF' }) -- Aura Mastery
Spell(407788, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Avenging Wrath
Spell(407957, { duration = 30, type = 'BUFF' }) -- Avenging Wrath
Spell(439733, { duration = INFINITY, type = 'BUFF' }) -- Tree of Life
Spell(439745, { duration = INFINITY, type = 'BUFF' }) -- Tree of Life (+10% heal)
Spell(440873, { duration = 10, type = 'BUFF', buffType = 'Magic' }) -- Decimation
Spell(440114, { duration = 10, type = 'BUFF' }) -- Sudden Death
Spell(440531, { duration = 4, type = 'BUFF' }) -- Hit and Run
Spell(439748, { duration = 10, type = 'BUFF' }) -- Starfall
Spell(457331, { duration = 6, type = 'BUFF' }) -- Avoidance
Spell(458312, { duration = 9, type = 'BUFF' }) -- Divine Protection
Spell(458371, { duration = 12, type = 'BUFF' }) -- Divine Protection
Spell(1213300, { duration = 8, type = 'BUFF' }) -- Divine Protection
Spell(459610, { duration = 7200, type = 'BUFF' }) -- Wanderer's Resolve
Spell(457437, { duration = 10, type = 'BUFF' }) -- Vanish (50% magic reduction)
Spell(459166, { duration = 86400, type = 'BUFF' }) -- Central Reaping Function 9000
Spell(458857, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Divine Light
Spell({ 457819, 457699, 457706, 457708 }, { duration = 5, type = 'BUFF' }) -- Echoes of X Stance
Spell(457342, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Clearcasting (rogue T1)
Spell(456549, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Melting Faces
Spell(461607, { duration = 3, type = 'BUFF' }) -- Divine Steed
Spell(460907, { duration = 10, type = 'BUFF' }) -- Demonic Frenzy
Spell({ 460940, 460939 }, { duration = 3600, type = 'BUFF' }) -- Might of Stormwind
Spell(461235, { duration = 15, type = 'BUFF' }) -- Moonstalker Fury
Spell(461226, { duration = 30, type = 'BUFF' }) -- Heart of the Treant
Spell({ 461224, 461317, 461227 }, { duration = 20, type = 'BUFF' }) -- Demon-Tainted Blood and other trinkets
Spell(461475, { duration = 7200, type = 'BUFF' }) -- Valor of Azeroth
Spell(462636, { duration = 15, type = 'BUFF' }) -- Chromatic Infusion
Spell(462707, { duration = 10, type = 'BUFF' }) -- Cutthroat
Spell(462853, { duration = 12, type = 'BUFF', buffType = 'Magic' }) -- Hand of Sacrifice
Spell(469144, { duration = 12, type = 'BUFF' }) -- Quick Strikes
Spell(469191, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Cassandra's Tome
Spell(468971, { duration = 3, type = 'BUFF' }) -- Windstriker
Spell(468408, { duration = 10, type = 'BUFF', buffType = 'Magic' }) -- Bloodlust
Spell(462374, { duration = 15, type = 'BUFF' }) -- Dive
Spell(468784, { duration = 20, type = 'BUFF' }) -- Echoes of Betrayal
Spell(467410, { duration = 10, type = 'BUFF', buffType = 'Magic' }) -- Brood Boon: Bronze
Spell(467511, { duration = 20, type = 'BUFF' }) -- Venomous Totem
Spell(468164, { duration = 10, type = 'BUFF' }) -- Pagle's Broken Reel
Spell(468512, { duration = 20, type = 'BUFF' }) -- Frost Potency
Spell(470108, { duration = 60, type = 'BUFF' }) -- Petrification
Spell(465414, { duration = 8, type = 'BUFF' }) -- Crusader's Zeal
Spell(467204, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Healing Grace
Spell(467467, { duration = 20, type = 'BUFF' }) -- Shapeshifter's Sigil
Spell(467742, { duration = 12, type = 'BUFF' }) -- Primal Blessing
Spell(469148, { duration = 10, type = 'BUFF' }) -- Kestrel
Spell(469828, { duration = 8, type = 'BUFF' }) -- Untamed Fury
Spell(468387, { duration = 20, type = 'BUFF' }) -- Aligned with Nature
Spell(467523, { duration = 20, type = 'BUFF' }) -- Nature Aligned
Spell(467522, { duration = 20, type = 'BUFF' }) -- Blinding Light
Spell(467543, { duration = 10, type = 'BUFF', buffType = 'Magic' }) -- Deliverance
Spell(468460, { duration = 20, type = 'BUFF' }) -- Energized Shield
Spell(468466, { duration = 8, type = 'BUFF' }) -- Unmaking the Simulacrum
Spell(468769, { duration = 5, type = 'BUFF' }) -- Nature Reflector
Spell(468183, { duration = 8, type = 'BUFF' }) -- Frenzy Effect
Spell(440591, { duration = 15, type = 'BUFF' }) -- Spirit Walk
Spell(468531, { duration = 15, type = 'BUFF' }) -- Rapid Healing
Spell(468540, { duration = 20, type = 'BUFF' }) -- Massive Destruction
Spell(467141, { duration = 20, type = 'BUFF' }) -- Mind Quickening
Spell(467525, { duration = 20, type = 'BUFF' }) -- Aegis of Preservation
Spell(473387, { duration = 7200, type = 'BUFF' }) -- Horn of the Dawn
Spell(473399, { duration = 3600, type = 'BUFF' }) -- Songflower Serenade
Spell(1214156, { duration = 6, type = 'BUFF' }) -- Spreading Rain
Spell(473403, { duration = 7200, type = 'BUFF' }) -- Blessing of Neptulon
Spell(473441, { duration = 3600, type = 'BUFF' }) -- Might of Blackrock
Spell(473450, { duration = 7200, type = 'BUFF' }) -- Dark Fortune of Damage
Spell(1213297, { duration = 6, type = 'BUFF' }) -- Badge of the Swarmguard
Spell(1214088, { duration = 20, type = 'BUFF' }) -- Infernalist
Spell(473476, { duration = 7200, type = 'BUFF' }) -- Spirit of Zandalar
Spell(1213972, { duration = 10, type = 'BUFF' }) -- Speed
Spell(474236, { duration = 6, type = 'BUFF' }) -- Blessing of Ji'zhi
Spell(1214278, { duration = 20, type = 'BUFF' }) -- Earthstrike
Spell(1214179, { duration = 300, type = 'BUFF' }) -- Furbolg Form
Spell(1214281, { duration = 300, type = 'BUFF' }) -- Naga Form
Spell(1214284, { duration = 300, type = 'BUFF' }) -- Drakonid Form
Spell(1213422, { duration = 15, type = 'BUFF' }) -- Aura of the Blue Dragon
Spell(1213209, { duration = 60, type = 'BUFF' }) -- Mercurial Shield
Spell(1214233, { duration = 30, type = 'BUFF' }) -- Obsidian Insight
Spell({ 474148, 474146 }, { duration = 15, type = 'BUFF' }) -- Swarming Thoughts
Spell(1215513, { duration = 6, type = 'BUFF', buffType = 'Magic' }) -- Holy Resistance
Spell(1215510, { duration = 6, type = 'BUFF', buffType = 'Magic' }) -- Frost Resistance
Spell(1215512, { duration = 6, type = 'BUFF', buffType = 'Magic' }) -- Shadow Resistance
Spell(473469, { duration = 3600, type = 'BUFF', buffType = 'Magic' }) -- Cleansed Firewater
Spell(1213375, { duration = 20, type = 'BUFF' }) -- The Burrower's Shell
Spell(1213234, { duration = 3, type = 'BUFF' }) -- Recomposed
Spell(1218485, { duration = 3600, type = 'BUFF' }) -- Draught of the Sands
Spell(1218072, { duration = 7200, type = 'BUFF' }) -- Blessing of Neptulon
Spell(1219232, { duration = 15, type = 'BUFF' }) -- Mind's Eye
Spell(1218075, { duration = 7200, type = 'BUFF' }) -- Dreams of Zandalar
Spell(1218074, { duration = 3600, type = 'BUFF' }) -- Might of Blackrock
Spell(1218121, { duration = 7200, type = 'BUFF' }) -- Horn of the Dawn
Spell(1218073, { duration = 7200, type = 'BUFF' }) -- Dark Fortune of Damage
Spell(1218574, { duration = 30, type = 'BUFF' }) -- Critical Aim
Spell(1220564, { duration = 300, type = 'BUFF' }) -- Bone Golem Form
Spell(1220561, { duration = 300, type = 'BUFF' }) -- Skeleton Form
Spell(1220560, { duration = 300, type = 'BUFF' }) -- Ghoul Form
Spell({1220543, 1220542, 1220545, 1220546}, { duration = 8, type = 'BUFF' }) -- Holy Power
Spell(1219500, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Kiss of the Spider
Spell(1219503, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- The Eye of Diminution
Spell(1220538, { duration = 3600, type = 'BUFF', buffType = 'Magic' }) -- Fire Protection
Spell(1219515, { duration = 20, type = 'BUFF' }) -- Essence of Sapphiron
Spell(1219519, { duration = 20, type = 'BUFF' }) -- Slayer's Crest
Spell({1219501, 1220659}, { duration = 20, type = 'BUFF' }) -- Loatheb's Reflection
Spell(1219072, { duration = 10, type = 'BUFF' }) -- Orders complete!
Spell(1219513, { duration = 30, type = 'BUFF', buffType = 'Magic' }) -- The Eye of the Dead
Spell(1219520, { duration = 20, type = 'BUFF' }) -- Glyph of Deflection
Spell(1220517, { duration = 60, type = 'BUFF', buffType = 'Magic' }) -- Bone Armor
Spell(1220668, { duration = 8, type = 'BUFF' }) -- Unholy Might
Spell(1220708, { duration = 10, type = 'BUFF' }) -- Displaced
Spell(1225778, { duration = 900, type = 'BUFF' }) -- Well Fed
Spell(1225779, { duration = 900, type = 'BUFF' }) -- Well Fed
Spell(1225780, { duration = 900, type = 'BUFF' }) -- Well Fed
Spell(1225782, { duration = 2700, type = 'BUFF' }) -- Well Fed
Spell(1225987, { duration = 8, type = 'BUFF' }) -- Tinker: Nitro Boosts
Spell(1225994, { duration = 8, type = 'BUFF' }) -- Tinker: Nitro Boosts
Spell(1226035, { duration = 15, type = 'BUFF' }) -- Swiftbloom
Spell(1226377, { duration = 6, type = 'BUFF' }) -- Timey Bearimy
Spell(1226105, { duration = 15, type = 'BUFF' }) -- Sunsurge
Spell(1226106, { duration = 15, type = 'BUFF' }) -- Moonsurge
Spell(1226451, { duration = 60, type = 'BUFF' }) -- Emergency
Spell(1226461, { duration = 15, type = 'BUFF' }) -- Holy Power
Spell(1226464, { duration = 10, type = 'BUFF' }) -- Templar
Spell(1226466, { duration = 6, type = 'BUFF' }) -- Righteous Shield
Spell(1226500, { duration = 15, type = 'BUFF' }) -- Absolution
Spell(1226502, { duration = 4, type = 'BUFF' }) -- Devotion
Spell(1227088, { duration = 15, type = 'BUFF' }) -- Swiftearth
Spell(1227200, { duration = 15, type = 'BUFF' }) -- Wickedness
Spell(1227700, { duration = 3, type = 'BUFF' }) -- Invisibility
Spell(1227772, { duration = 300, type = 'BUFF' }) -- Rapid Fire
Spell(1229045, { duration = 14400, type = 'BUFF' }) -- Friend of Pupper
Spell(1230596, { duration = 30, type = 'BUFF', buffType = 'Magic' }) -- Ashbringer
Spell(1230980, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Stiltz's Standard
Spell(1230944, { duration = 30, type = 'BUFF' }) -- Sir Dornel's Didgeridoo
Spell(1230942, { duration = 20, type = 'BUFF' }) -- Heart of Light
Spell(1230990, { duration = 10, type = 'BUFF' }) -- Molten Armaments
Spell(1231124, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Righteous Strength
Spell(1231138, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Righteous Fire
Spell(1231162, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Righteous Blasting
Spell(1231227, { duration = 2, type = 'BUFF' }) -- Reborn Inspiration
Spell(1231230, { duration = 2, type = 'BUFF' }) -- Reborn Inspiration
Spell(1231231, { duration = 2, type = 'BUFF' }) -- Reborn Inspiration
Spell(1231254, { duration = 10, type = 'BUFF' }) -- Scarlet Bulwark
Spell(1231266, { duration = 15, type = 'BUFF' }) -- En Garde
Spell(1231289, { duration = 15, type = 'BUFF' }) -- Avatar of the Mountain
Spell(1231339, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Corrupted Strength
Spell(1231383, { duration = 15, type = 'BUFF' }) -- Divine Avatar
Spell(1231402, { duration = 15, type = 'BUFF' }) -- Lightfist Flurry
Spell(1231406, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Corrupted Agility
Spell(1231436, { duration = 10, type = 'BUFF' }) -- Regicide
Spell(1231444, { duration = 10, type = 'BUFF', buffType = 'Magic' }) -- Eat Apple
Spell(1231456, { duration = 12, type = 'BUFF', buffType = 'Magic' }) -- Crimson Crusade
Spell(1231498, { duration = 12, type = 'BUFF', buffType = 'Magic' }) -- Mercy by Fire
Spell(1231548, { duration = 15, type = 'BUFF' }) -- Holy Might
Spell(1231551, { duration = 15, type = 'BUFF' }) -- Holy Might
Spell(1231585, { duration = 60, type = 'BUFF' }) -- Tidal Force
Spell(1231590, { duration = 20, type = 'BUFF', buffType = "" }) -- Bestial Focus
Spell(1231591, { duration = 20, type = 'BUFF', buffType = "" }) -- Bestial Focus
Spell(1231625, { duration = 20, type = 'BUFF' }) -- Flames of the Red
Spell(1231623, { duration = 15, type = 'BUFF' }) -- Tyr's Return
Spell(1231929, { duration = 600, type = 'BUFF' }) -- Scarlet Illusion
Spell(1231874, { duration = 30, type = 'BUFF' }) -- Abandoned Experiment
Spell(1231883, { duration = INFINITY, type = 'BUFF' }) -- Strength of the Bear
Spell(1231884, { duration = INFINITY, type = 'BUFF' }) -- Accuracy of the Owl
Spell(1231886, { duration = INFINITY, type = 'BUFF' }) -- Speed of the Cat
Spell(1231888, { duration = INFINITY, type = 'BUFF' }) -- Agility of the Raptor
Spell(1231891, { duration = INFINITY, type = 'BUFF' }) -- Power of the Gorilla
Spell(1231894, { duration = INFINITY, type = 'BUFF' }) -- Ferocity of the Crocolisk
Spell(1231896, { duration = INFINITY, type = 'BUFF' }) -- Brilliance of Mr. Bigglesworth
Spell(1232052, { duration = 15, type = 'BUFF' }) -- Heads
Spell(1232169, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Righteous Inquisition
Spell(1232581, { duration = INFINITY, type = 'BUFF' }) -- Liberation Aura
Spell(1232575, { duration = INFINITY, type = 'BUFF' }) -- Guardian Aura
Spell(1232553, { duration = INFINITY, type = 'BUFF' }) -- Dominance Aura
Spell(1232383, { duration = INFINITY, type = 'BUFF' }) -- Dominance Aura
Spell(1232703, { duration = INFINITY, type = 'BUFF' }) -- Retribution Aura
Spell(1232734, { duration = 20, type = 'BUFF', buffType = 'Magic' }) -- Renew
Spell(1233293, { duration = 30, type = 'BUFF', buffType = '' }) -- Battle Cry
Spell(1227369, { duration = 15, type = 'BUFF', buffType = 'Magic' }) -- Searing Flames
Spell(1233525, { duration = 20, type = 'BUFF' }) -- Avenging Shield
Spell(1232710, { duration = 8, type = 'BUFF', buffType = 'Magic' }) -- Seal of Protection
Spell(1233835, { duration = 15, type = 'BUFF' }) -- Thunder and Lava
Spell(1232959, { duration = 20, type = 'BUFF' }) -- Strand of Fate
Spell({ 1235119, 1235122 }, { duration = 1800, type = 'BUFF' }) -- Ninja Costume
Spell(1233988, { duration = 20, type = 'BUFF' }) -- Infernalist Armor
Spell(1234320, { duration = 7, type = 'BUFF' }) -- Epoch's End
Spell(1234542, { duration = 10, type = 'BUFF' }) -- Redeemed
Spell(1234071, { duration = 15, type = 'BUFF' }) -- Flurry of Blades
Spell(1234067, { duration = 15, type = 'BUFF' }) -- Gladiator's Cunning
Spell({ 1235390, 1235353 }, { duration = 12, type = 'BUFF' }) -- Mercy by Fire


-------------
-- MOUNTS
-------------

Spell(17481, { duration = FAKE, type = "BUFF" }) -- Deathcharger's Reins
Spell(24252, { duration = FAKE, type = "BUFF" }) -- Swift Zulian Tiger
Spell(23509, { duration = FAKE, type = "BUFF" }) -- Horn of the Frostwolf Howler
Spell(17229, { duration = FAKE, type = "BUFF" }) -- Reins of the Winterspring Frostsaber
Spell(26656, { duration = FAKE, type = "BUFF" }) -- Black Qiraji Resonating Crystal
Spell(24242, { duration = FAKE, type = "BUFF" }) -- Swift Razzashi Raptor
Spell(23510, { duration = FAKE, type = "BUFF" }) -- Stormpike Battle Charger
Spell(470, { duration = FAKE, type = "BUFF" }) -- Black Stallion Bridle
Spell(22723, { duration = FAKE, type = "BUFF" }) -- Reins of the Black War Tiger
Spell(472, { duration = FAKE, type = "BUFF" }) -- Pinto Bridle
Spell(23221, { duration = FAKE, type = "BUFF" }) -- Reins of the Swift Frostsaber
Spell(23227, { duration = FAKE, type = "BUFF" }) -- Swift Palomino
Spell(23228, { duration = FAKE, type = "BUFF" }) -- Swift White Steed
Spell(6648, { duration = FAKE, type = "BUFF" }) -- Chestnut Mare Bridle
Spell(458, { duration = FAKE, type = "BUFF" }) -- Brown Horse Bridle
Spell(23338, { duration = FAKE, type = "BUFF" }) -- Reins of the Swift Stormsaber
Spell(23219, { duration = FAKE, type = "BUFF" }) -- Reins of the Swift Mistsaber
Spell(22721, { duration = FAKE, type = "BUFF" }) -- Whistle of the Black War Raptor
Spell(23229, { duration = FAKE, type = "BUFF" }) -- Swift Brown Steed
Spell(22717, { duration = FAKE, type = "BUFF" }) -- Black War Steed Bridle
Spell(10793, { duration = FAKE, type = "BUFF" }) -- Reins of the Striped Nightsaber
Spell(22722, { duration = FAKE, type = "BUFF" }) -- Red Skeletal Warhorse
Spell(18791, { duration = FAKE, type = "BUFF" }) -- Purple Skeletal Warhorse
Spell(10789, { duration = FAKE, type = "BUFF" }) -- Reins of the Spotted Frostsaber
Spell(18245, { duration = FAKE, type = "BUFF" }) -- Horn of the Black War Wolf
Spell(6653, { duration = FAKE, type = "BUFF" }) -- Horn of the Dire Wolf
Spell(23241, { duration = FAKE, type = "BUFF" }) -- Swift Blue Raptor
Spell(8394, { duration = FAKE, type = "BUFF" }) -- Reins of the Striped Frostsaber
Spell(23250, { duration = FAKE, type = "BUFF" }) -- Horn of the Swift Brown Wolf
Spell(22718, { duration = FAKE, type = "BUFF" }) -- Black War Kodo
Spell(580, { duration = FAKE, type = "BUFF" }) -- Horn of the Timber Wolf
Spell(17463, { duration = FAKE, type = "BUFF" }) -- Blue Skeletal Horse
Spell(23251, { duration = FAKE, type = "BUFF" }) -- Horn of the Swift Timber Wolf
Spell(23243, { duration = FAKE, type = "BUFF" }) -- Swift Orange Raptor
Spell(17465, { duration = FAKE, type = "BUFF" }) -- Green Skeletal Warhorse
Spell(22720, { duration = FAKE, type = "BUFF" }) -- Black War Ram
Spell(8395, { duration = FAKE, type = "BUFF" }) -- Whistle of the Emerald Raptor
Spell(6654, { duration = FAKE, type = "BUFF" }) -- Horn of the Brown Wolf
Spell(17462, { duration = FAKE, type = "BUFF" }) -- Red Skeletal Horse
Spell(23240, { duration = FAKE, type = "BUFF" }) -- Swift White Ram
Spell(23252, { duration = FAKE, type = "BUFF" }) -- Horn of the Swift Gray Wolf
Spell(23247, { duration = FAKE, type = "BUFF" }) -- Great White Kodo
Spell(23242, { duration = FAKE, type = "BUFF" }) -- Swift Olive Raptor
Spell(23225, { duration = FAKE, type = "BUFF" }) -- Swift Green Mechanostrider
Spell(10969, { duration = FAKE, type = "BUFF" }) -- Blue Mechanostrider
Spell(10799, { duration = FAKE, type = "BUFF" }) -- Whistle of the Violet Raptor
Spell(22719, { duration = FAKE, type = "BUFF" }) -- Black Battlestrider
Spell(6898, { duration = FAKE, type = "BUFF" }) -- White Ram
Spell(17464, { duration = FAKE, type = "BUFF" }) -- Brown Skeletal Horse
Spell(17454, { duration = FAKE, type = "BUFF" }) -- Unpainted Mechanostrider
Spell(23223, { duration = FAKE, type = "BUFF" }) -- Swift White Mechanostrider
Spell(10796, { duration = FAKE, type = "BUFF" }) -- Whistle of the Turquoise Raptor
Spell(23238, { duration = FAKE, type = "BUFF" }) -- Swift Brown Ram
Spell(23239, { duration = FAKE, type = "BUFF" }) -- Swift Gray Ram
Spell(6899, { duration = FAKE, type = "BUFF" }) -- Brown Ram
Spell(6777, { duration = FAKE, type = "BUFF" }) -- Gray Ram
Spell(10873, { duration = FAKE, type = "BUFF" }) -- Red Mechanostrider
Spell(23249, { duration = FAKE, type = "BUFF" }) -- Great Brown Kodo
Spell(18989, { duration = FAKE, type = "BUFF" }) -- Gray Kodo
Spell(18990, { duration = FAKE, type = "BUFF" }) -- Brown Kodo
Spell(23248, { duration = FAKE, type = "BUFF" }) -- Great Gray Kodo
Spell(23222, { duration = FAKE, type = "BUFF" }) -- Swift Yellow Mechanostrider
Spell(17453, { duration = FAKE, type = "BUFF" }) -- Green Mechanostrider
Spell(23214, { duration = FAKE, type = "BUFF" }) -- Summon Charger
Spell(13819, { duration = FAKE, type = "BUFF" }) -- Summon Warhorse
Spell(23161, { duration = FAKE, type = "BUFF" }) -- Summon Dreadsteed
Spell(5784, { duration = FAKE, type = "BUFF" }) -- Summon Felsteed
Spell(436288, { duration = FAKE, type = "BUFF" }) -- Mottled Blood Raptor
Spell(436327, { duration = FAKE, type = "BUFF" }) -- Bengal Tiger
Spell(429856, { duration = FAKE, type = "BUFF" }) -- Summon Sentinel Nightsaber
Spell(429857, { duration = FAKE, type = "BUFF" }) -- Summon Outrider Wolf
Spell(436289, { duration = FAKE, type = "BUFF" }) -- Ivory Raptor
Spell(436329, { duration = FAKE, type = "BUFF" }) -- Golden Sabercat
Spell(17458, { duration = FAKE, type = 'BUFF' }) -- 'Fluorescent Green Mechanostrider'", -- [640]
Spell(446685, { duration = FAKE, type = 'BUFF' }) -- Blood-crazed Spirit
Spell(1215378, { duration = FAKE, type = 'BUFF' }) -- Blood-Caked Tiger
Spell(1215380, { duration = FAKE, type = 'BUFF' }) -- Blood-Caked Raptor
Spell(1220568, { duration = FAKE, type = 'BUFF' }) -- Famine
Spell(1220566, { duration = FAKE, type = 'BUFF' }) -- Conquest
Spell(1220567, { duration = FAKE, type = 'BUFF' }) -- Death
Spell(1220565, { duration = FAKE, type = 'BUFF' }) -- War
Spell(1229305, { duration = FAKE, type = 'BUFF' }) -- Climhazzard
Spell(1229308, { duration = FAKE, type = 'BUFF' }) -- Scarlet Steed
-------------
-- ITEMS
-------------

Spell(17670, { duration = GHOST, type = "BUFF" }) -- Argent Dawn Commission
Spell(29506, { duration = 20, type = "BUFF" }) -- The Burrower's Shell
Spell({ 17543, 18942, 17548, 17549, 7240, 17544, 7250, 29432, 7235, 7254 }, { duration = 3600, type = "BUFF" }) -- Potion Protection
Spell(23991, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Damage Absorb
Spell(23506, { duration = 20, type = "BUFF", buffType = "Magic" }) -- Aura of Protection
Spell({ 17730, 128, 17729 }, { duration = 60, type = "BUFF", buffType = "Magic" }) -- Spellstone
Spell(10368, { duration = 15, type = "BUFF", buffType = "Magic" }) -- Uther's Light Effect
Spell(13234, { duration = 600, type = "BUFF" }) -- Harm Prevention Belt
Spell(24021, { duration = 8, type = "BUFF" }) -- Anti-Magic Shield
Spell(7121, { duration = 10, type = "BUFF" }) -- Anti-Magic Shield
Spell({ 1135, 446714, 26473, 26402, 1133, 24355, 1137, 29007, 26261, 26475, 25696 }, { duration = 30, type = 'BUFF' }) -- 'Drink'", -- [314]
Spell({ 1129, 1131, 25660, 24800, 18124, 10257, 18071, 22731, 23692, 26030, 18234, 25695, 24005, 25697, 26260, 26401, 26474, 29008, 18230, 18233 }, { duration = 30, type = 'BUFF' }) -- 'Food'", -- [345]
Spell(432, { duration = 24, type = 'BUFF' }) -- 'Drink'", -- [377]
Spell({ 26475, 446713, 468767 }, { duration = 30, type = 'BUFF' }) -- 'Drink'", -- [633]
Spell(10256, { duration = 30, type = 'BUFF' }) -- 'Food'", -- [569]
Spell(1127, { duration = 27, type = 'BUFF' }) -- 'Food'", -- [398]
Spell(5007, { duration = 27, type = 'BUFF' }) -- 'Food'", -- [411]
Spell(25888, { duration = 21, type = 'BUFF' }) -- 'Food'", -- [542]
Spell(25889, { duration = 21, type = 'BUFF' }) -- 'Brain Food'", -- [543]
Spell(25941, { duration = 900, type = 'BUFF' }) -- 'Well Fed'", -- [544]
Spell(25804, { duration = 900, type = 'BUFF' }) -- 'Rumsey Rum Black Label'", -- [550]
Spell(7844, { duration = 1800, type = 'BUFF' }) -- 'Fire Power'", -- [551]
Spell(439959, { duration = 1800, type = 'BUFF' }) -- 'Lesser Arcane Elixir'", -- [552]
Spell(11390, { duration = 1800, type = 'BUFF' }) -- Arcane Elixir

lib:SetDataVersion(Type, Version)
