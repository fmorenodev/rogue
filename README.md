# ROGUE 

a GODOT-based roguelike

## IMPLEMENT:
- world generation
	- ~~improve world gen to make it tile_based~~
	- tweak new world gen
	- possibly expand rooms to fit on all non-corridor space and other smaller rooms
	- ~~fix positioning issue for entities upon spawn~~
	- ~~fix world gen upon retry/new dungeon level (less entities spawn?)~~
- improve spawning to make it more evenly distributed
	- ~~no spawning in corridor entrances (find how to detect them)~~
	- ~~fix entities spawning upon the player~~
	- add the corridor finding function to the spawning function when better rooms are able to be generated
- implement visibility map / fog
	- show visible / revealed entities only on GUI
- map clearing and advancing to the next map
- player interaction with entities
	- item pickup (using inventory)
	- object specific interaction (like opening chests)
	- skills and ranged attacks
	- neutral or allied interactions with actors
- inventory
- implement neutral and ally NPCs
- leveling system
- loading screen
	- ~~make graphic/animation for loading screen~~
	- fix loading / event order to make it dissappear when the map is generated
- refactor nodes and scripts to make each node or script do less things and be more organized
	- refactor turn system ??
	- fix diagonal movement / pressing two or more movement inputs at the same time. Add (diagonal) movement with vi / num keys or with two directional keys
- general fixes
	- add a new tile for the background to distinguish it

## DESIGN: when designed move to implement with the decided implementation
- decide on aesthetic for the game
	- bw / 1 bit (maybe)
	- realistic color palette (i don't think so)
	- limited color palette (maybe)
	- setting / aesthetic based new fonts (must search first)
- decide on setting for the game
	- oniric / surreal (decided)
- bigger tiles?
	- 32 x 32
	- asymmetric (16 x 32)
- design and decide additional inputs:
	- open screen:
		- menu
		- char sheet
		- log / quests / relations
		- map ?
		- inventory
		- etc
	- alternative interactions:
		- talk
		- shoot / skill / magic
		- look at tile
		- etc
- design additional entities
- design expected enemy behaviour
	- universal enemy AI
	- specfic enemy AI
	- enemy death behaviour
- design classes or loadouts
	- implement skills / perks / etc
- menu styling
	- create better design for the menus
	- graphics based on setting / aesthetic
