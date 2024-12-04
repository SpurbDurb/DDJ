extends Node3D

@export var scene_to_spawn: PackedScene

var spawned_instance: Node = null

func _process(_delta):
	if spawned_instance == null:
		var new_obj = scene_to_spawn.instantiate()
		new_obj.transform = transform 
		get_parent().add_child(new_obj)
		spawned_instance = new_obj
