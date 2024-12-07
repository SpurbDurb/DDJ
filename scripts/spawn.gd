extends Node3D

@export var scene_to_spawn: PackedScene
@export var fall_threshold: float = -10.0  

var spawned_instance: Node = null

func _process(_delta):
	if spawned_instance == null:
		_spawn()
		return

	if spawned_instance.spawn == false:
		queue_free()
		return
	if spawned_instance.global_transform.origin.y < fall_threshold:
		_respawn()

func _respawn():
	if spawned_instance:
		spawned_instance.queue_free()
		await get_tree().process_frame
	_spawn()

func _spawn():
	var new_obj = scene_to_spawn.instantiate()
	new_obj.transform = transform 
	spawned_instance = new_obj
	get_parent().add_child(spawned_instance)
