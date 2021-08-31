extends Node

# GUI
var white = "ffffff" # default color
var light_gray = "cccccc" # gui borders
var cyan = "8ffcff" # player attacks
var light_red = "ff5252" # enemy attacks
var red = "a70000" # enemy is dead
var dark_red = "530000" # player is dead
var gold = "a67c00" 
var grey = "777777" # new level

func rand_color() -> Color:
	return Color.from_hsv(rand_range(0, 6), 0.5, 1)
