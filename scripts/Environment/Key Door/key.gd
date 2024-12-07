extends RigidBody3D

@export var spawn: bool = true
var used: bool = false

func use():
	#spawn = false
	queue_free()
