# ROGUE 

a GODOT-based roguelike

## IMPLEMENT:
- player interaction with entities
	- ~~skills and ranged attacks~~
		- add animation to skills
	- ~~targeting system~~
		- calculate the tiles behind a wall / a solid entity so the shot cannot reach them
- actor interaction
	- allies interacting
	- ally / enemy interaction with items
- implement neutral and ally NPCs
	- new designs
	- different ai on each mob
	- better pathfinding to avoid enemies blocking each other (see last fix)
- map clearing and advancing to the next map	
	- rewards for clearing map
- loading screen
	- fix loading / event order to make it dissappear when the map is generated
	- add new animation
- general fixes / improvements
	- fix entity info extra space
	- check colors for log text
	- adjust margins for gui
	- mouse wheel is an InputEventMouseButton? need to control that 
	- move assets to be preloaded in another node / script (grid or something like a singleton in global)
	- improve spawning to make it more evenly distributed
	- fix diagonal movement / pressing two or more movement inputs at the same time.
	- when calculating a path, if the path is blocked by an entity, move around (or possibly update the a* map with the square each untraversable entity occupies at the end of each turn)

## DESIGN: when designed move to implement with the decided implementation
- design and decide additional inputs:
	- open screen:
		- char sheet
		- log
	- alternative interactions:
		- look at tile
- design classes or loadouts
	- implement skills / perks / etc
- menu styling
	- create better design for the menus
