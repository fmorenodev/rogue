# ROGUE 

a GODOT-based roguelike

## IMPLEMENT:
- sounds and attack animations:
	- ~~implemented sound and animations to the basic actor attacks~~
	- ~~added some sounds~~
- player interaction with entities
	- skills and ranged attacks
	- targeting system
	- ~~neutral or allied interactions with actors~~
- actor interaction
	- allies interacting
	- ally / enemy interaction with items
- implement neutral and ally NPCs
	- new designs
	- different ai on each mob
- map clearing and advancing to the next map	
	- rewards for clearing map
- loading screen
	- fix loading / event order to make it dissappear when the map is generated
	- add new animation
- general fixes / improvements
	- move assets to be preloaded in another node / script (grid or something like a singleton in global)
	- improve spawning to make it more evenly distributed
	- fix diagonal movement / pressing two or more movement inputs at the same time.
	- ~~fix allied info sharing the same vars on allies and player~~
	- ~~consider managing dead status (entity removal, dead status is calculated in entity) in actor class, after figuring out how to move it from grid~~
	- bug: when calculating a path, if the path is blocked by an entity, move around (or possibly update the a* map with the square each untraversable entity occupies at the end of each turn)

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
