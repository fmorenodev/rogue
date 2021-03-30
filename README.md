# ROGUE 

a GODOT-based roguelike

## TODO:
- ~~project setup~~
- ~~world generation~~
	- improve world gen to make it tile_based
	- fix world gen upon retry/new dungeon level
- ~~player movement~~
- ~~make get_available_position check for possible entities in the position~~
- ~~make basic entities:~~
	- ~~enemies~~
- ~~objects (chests, doors, traps, etc)~~
- ~~items~~
- ~~spawn entities~~
- expand upon basic entities
	- more entities
- improve spawning to make it more evenly distributed
	- no spawning in corridor entrances (find how to detect them)
	- fix entities spawning upon the player
- ~~player interaction with entities~~
	- more interactions
- inventory
- ~~game over and game restart~~
- enemy behaviour
- ~~turn implementation~~
- autotiling
- complete map and advance to next one
- ~~start screen~~
- leveling system
- GUI
	- ~~Player info~~
	- Enemies/objects/items info
	- add info for entities with animations
	- ~~log system~~
	- -~~add existing actions to log system~~
	- fix signal coupling for info elements
- search for new fonts for the game and menus
- menu styling
	- create better design for the menus
	- ~~custom styling for focus and hover on buttons~~
	- graphics
- ~~loading screen~~
	- ~~make graphic/animation for loading screen~~
- refactor nodes and scripts to make each node or script do less things and be more organized
	- refactor turn system
	- fix diagonal movement / pressing two or more movement inputs at the same time. Add (diagonal) movement with vi / num keys or with two directional keys
