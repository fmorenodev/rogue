extends RigidBody2D

var size

func make_room(pos, r_size):
	position = pos
	size = r_size
	var shape = RectangleShape2D.new()
	shape.custom_solver_bias = 2
	shape.extents = size
	$CollisionShape2D.shape = shape

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
