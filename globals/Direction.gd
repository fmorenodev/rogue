extends Node

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

const UP_LEFT = Vector2(-1, -1)
const UP_RIGHT = Vector2(1, -1)
const DOWN_LEFT = Vector2(-1, 1)
const DOWN_RIGHT = Vector2(1, 1)

func rand_dir() -> Vector2:
	DIRECTIONS.shuffle()
	return DIRECTIONS.front()
