Meta structure:
MainGame starts
'MainGame' contains Systems (the managers which interact with multiple other pieces. like, player health, the hud, etc.)
'World' is the container for what spawns in the world (level, effects, entities), moves with the camera
- LevelRoot is a sub-container for loading the levels
- EntityRoot is a sub container for the player, enemies, pickups, etc.
- EffectRoot is for temporary visual effects (like???????)
HudLayer is the container for the various hud elements (health, ammo, etc.)
- HudLayer has a HudRoot
PauseLayer is the container for the pause menu and its effects (pausing the game, showing options, etc.)
- PauseLayer has a PauseRoot
TransitionLayer is a container for transitioning between the various levels (controlling how transitioning looks)
- TransitionLayer has a TransitionRoot
DebugLayer is a container for debug objects (fps, # entities, current modes, other stuff to display)
- DebugLayer has a DebugRoot
