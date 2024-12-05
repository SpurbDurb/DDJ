extends Node3D

@export var scene_to_spawn: PackedScene

var spawned_instance: Node = null
@export var fall_threshold: float = -10.0  # limite para ser considerado morte do jogador


func _process(_delta):
	if spawned_instance == null:
		_spawn_player()
	else:
		# Se o jogador caiu
		if spawned_instance.global_transform.origin.y < fall_threshold:
			_respawn_player()

func _respawn_player():
	# Remover instancia antiga do jogador
	if spawned_instance:
		spawned_instance.queue_free()
		await get_tree().process_frame  # Fix bug player remained in scene 
	_spawn_player()

func _spawn_player():
	var new_obj = scene_to_spawn.instantiate()
	new_obj.transform = transform 
	spawned_instance = new_obj
	get_parent().add_child(spawned_instance)
	print("Player ", new_obj.name, " spawned")
