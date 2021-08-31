extends Node

const UP_LEFT = Vector2(-1, -1)
const UP_RIGHT = Vector2(1, -1)
const DOWN_LEFT = Vector2(-1, 1)
const DOWN_RIGHT = Vector2(1, 1)

const BASIC_DIRECTIONS = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]

const DIRECTIONS = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT,
					UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT]

func rand_dir() -> Vector2:
	DIRECTIONS.shuffle()
	return DIRECTIONS.front()
