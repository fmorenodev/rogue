extends RigidBody2D

var size
var rect

func make_room(pos, r_size):
	position = pos
	size = r_size
	var shape = RectangleShape2D.new()
	shape.custom_solver_bias = 2
	shape.extents = size
	$CollisionShape2D.shape = shape
