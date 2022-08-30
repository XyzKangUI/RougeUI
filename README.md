# RougeUI

This is my **_personal_** UI for Wotlk-Classic. It is heavily inspired by ModUI. 
# **Feature List:**

- All frames can manually be darkened under "Misc" options by using the slider (incl. nameplates).
- Personal/Target (de)buffs can be re-sized.
- Activate spells on pressing keys down (like SnowFallKeyPress).
- ModUI's border style.
- ModUI castbar style
- Smooth animated Health and Mana bars.
- Statusbar numeric text is shown as the _current_ HP/Mana. The numeric display can be shortened to one decimal.
- Combat Indicator on target-/focus frame.
- Fade PvP Icons
- Sets the correct Player PvP icon when you get queued as Horde <> Alliance in a crossfaction battleground.
- Hide all glows, spammy damage indicators and group/raid titles.
- Removed server names on raidframes and nameplates.
- Force enabled nameplate's hidden castbar text.
- Hidden nameplates to reduce clutter: feral spirit, treants, risen ghoul, army of the dead, snake trap, mirror image 
- The duration timer gap can be removed from buffs
- Highlight dispellable magic (blue) & enrage buffs (red). Only [important](https://github.com/XyzKangUI/RougeUI/blob/wotlk/Interface/AddOns/RougeUI/auras.lua#L121/) magic buffs are highlighted and also aura mastery (yellow) + lichborne (pink).
- Class colored names on the PvP Scoreboard (BG's).
- Class colored and/or gradient health bars.
- Class portraits (unique custom textures).
- Class portrait outlines

# **Read Me:**

Every option listed in the feature list can be **MANUALLY** enabled in Interface Options > AddOns > RougeUI-TBCC. The addon itself does not come pre-configured with any setting other than the darkened frames. After enabling/disabling an option (or more) you need to /reload in game or hit the "Save & Reload" button. The reason behind this implementation is because RougeUI has been made modular. This means that __the addon initially uses 0% of you CPU__ because only the enabled things truly get loaded. Some features in the addon will use some CPU usage, such as the Smooth Animated HP/Mana bars (__RECOMMENDED!__), combat indicator or energy ticker. This in reality is not of any concern, but some may care about statistics.

# **Images:**

Smooth Animated Health and Mana (lagging .gif)


<img src="https://user-images.githubusercontent.com/94811434/142790521-636a4814-0ed5-423b-9361-2db0c91be807.gif" width=50% height=50%>


Initial CPU Usage:

<img src="https://user-images.githubusercontent.com/94811434/146589205-c86ded89-d997-464f-a4e0-af249555c1af.png" width=75% height=75%>




# **BUGS:**

I have been using this addon for 2 years. There are no bugs or errors. If you do encounter any issue, then please refrain from opening a topic before disabling all other addons.

# **Credits:**

A lot of the code is kanged, ergo credits should be given where they are due: 
* Swagkhalifa: help with smooth animated nameplate bars + as bonus gave gradient castbar effect.
* Knall: for the always continuous help
* Modernist for making the best addon hands down and inspiring me to bring over a few features from his 1.12 UI; energy ticker; spellbars; nameplates; smooth animated statusbars.
* Usoltev for the auras code.
* Lorti/Chordsy/Syiana for some of the copypasta. 
* Shanghi/ModUI for smoothened animation bars.
* The rest not mentioned here :D
