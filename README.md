# RougeUI

This is my **_personal_** UI for TBC-Classic. It is heavily inspired on a few elements from ModUI, LortiUI (black textures only) and SchakaPvPUI.

# **Feature List:**

- Dark frames (incl. nameplates).
- Hide all glows, spammy damage indicators and group/raid titles.
- Smooth animated Health and Mana bars.
- Sets the correct Player PvP icon when you get queued as Horde <> Alliance in a crossfaction battleground.
- Removed server names showing on raid frames when in BG/Arena.
- Class colored names on the PvP Scoreboard in battlegrounds.
- Combat Indicator on target-/focus frame.
- Added timers + gradient effect + changed spelltext position (modui style) to castbars.
- Enabled nameplate's hidden castbar text.
- Built-in energy ticker for druids and rogues.
- Faded PvP Icons. Useful for combo point classes because they overlap.
- Removed gap and re-colored the buff duration format.
- Personal/Target (de)buffs can be re-sized.
- Highlight dispellable magic buffs.
- Fast key actions (like SnowFallKeyPress).
- Class colored and/or gradient health bars.
- Class portraits.
- Statusbar numeric text is shown as the _current_ HP/Mana. The numeric display can be shortened to one decimal.

# **Read Me:**

Every option listed in the feature list can be **MANUALLY** enabled in Interface Options > AddOns > RougeUI-TBCC. The addon itself does not come pre-configured with any setting other than the darkened frames. After enabling/disabling an option (or more) you need to /reload in game or hit the "Save & Reload" button. The reason behind this implementation is because RougeUI has been made modular. This means that __the addon initially uses 0% of you CPU__ because only the enabled things truly get loaded. Some features in the addon will use some CPU usage, such as the Smooth Animated HP/Mana bars (__WORTH IT, RECOMMENDED!__). Some features will simply (get the blame) use CPU because they are either hooking into blizzard's function that is used a lot or are making use of the OnUpdate handler. It is what it is.

# **Images:**

Animated Health and Mana (laggy gif)


<img src="https://user-images.githubusercontent.com/94811434/142790521-636a4814-0ed5-423b-9361-2db0c91be807.gif" width=50% height=50%>

RougeUI with Masque + Blizzbuffsfacade (Retina skin) + Dominos

<img src="https://user-images.githubusercontent.com/94811434/145716066-1c8d5ac7-6fa6-4780-b5f6-6fa5eddb82ea.png" width=100% height=100%>

Initial CPU Usage:

<img src="https://user-images.githubusercontent.com/94811434/146589205-c86ded89-d997-464f-a4e0-af249555c1af.png" width=75% height=75%>




# **BUGS:**

I have been using this addon for 2 years. There are no bugs or errors. If you do encounter any issue, then please refrain from opening a topic before disabling all other addons.

# **Credits:**

A lot of the code is kanged, ergo credits should be given where they are due: 
* Swagkhalifa: help with smooth animated bars + gradient castbar effect.
* Knall: for fixing the nameplate castbar hook C overflow and the combat indicator.
* Modernist for making the best addon hands down and inspiring me to bring over a few features from his 1.12 UI; energy ticker; spellbars; nameplates; smooth animated statusbars.
* Usoltev for the auras code.
* SchakaPvPUI (modded version as seen in Sbkzor's vids) for the inspiration.
* Lorti/Chordsy/Syiana for some of the copypasta. 
* Shanghi for his tbc 2.4.3 smooth animated bars fix.
* The rest not mentioned here :D

**Notes:**

The addon does not theme your buffs/debuffs or change them such as Lorti and ModUI do. I suggest using any of the following addons:
- Masque required: https://www.curseforge.com/wow/addons/blizzbuffsfacade
- Raven: https://www.curseforge.com/wow/addons/raven
