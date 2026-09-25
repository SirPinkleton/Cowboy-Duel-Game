Scene Structure:
MainGame co-ordinates the larger pieces and loads on start. it owns owns loading systems, world, hud, pause, debug nodes
-does not micromanage or know specifics about what they do

Level scenes own level-local objects. Geometry, tilemapping, player/enemy spawns, back/foregrounds, etc.
-does not know the player scene to instantiate, how the hud gets updated, how camera connects to player, etc.

Interactables and gameplay elements own themselves, and only themselves.
