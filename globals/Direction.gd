extends Node

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

const up_left = Vector2(-1, -1)
const up_right = Vector2(1, -1)
const down_left = Vector2(-1, 1)
const down_right = Vector2(1, 1)

func rand_dir():
	DIRECTIONS.shuffle()
	return DIRECTIONS.front()
