# RougeUI

This is my **_personal_** UI for TBC-Classic. It is heavily inspired on a few elements from ModUI, LortiUI (black textures only) and SchakaPvPUI.

# **Feature List:**

- Dark frames (incl. nameplates).
- ModUI's border style on actionbar and aura's (dark).
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

Every option listed in the feature list can be **MANUALLY** enabled in Interface Options > AddOns > RougeUI-TBCC. The addon itself does not come pre-configured with any setting other than the darkened frames. After enabling/disabling an option (or more) you need to /reload in game or hit the "Save & Reload" button. The reason behind this implementation is because RougeUI has been made modular. This means that __the addon initially uses 0% of you CPU__ because only the enabled things truly get loaded. Some features in the addon will use some CPU usage, such as the Smooth Animated HP/Mana bars (__WORTH IT, RECOMMENDED!__), class colored hp or energy ticker. This in reality is not of any concern, but some may care about statistics.

# **Images:**

Smooth Animated Health and Mana (lagging .gif)


<img src="https://user-images.githubusercontent.com/94811434/142790521-636a4814-0ed5-423b-9361-2db0c91be807.gif" width=50% height=50%>


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
* Lorti/Chordsy/Syiana for some of the copypasta. 
* Shanghi/ModUI for smoothened animation bars.
* The rest not mentioned here :D
