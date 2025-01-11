extends Node

const LEVELS = preload("res://scripts/Managers/Level Manager/levels.tres")
var level := 0
var level_position := Vector3.ZERO
var level_up_offset := Vector3(0,6,0)

var spawn_delay := 0.2
var base_level_node

func _ready() -> void:
	base_level_node = get_tree().root.get_node("Base/Level")

func level_up():
	open_level(level + 1)

func open_level(new_level: int):
	level = new_level
	if level > LEVELS.level_list.size(): return
	var next_level_scene = LEVELS.level_list[level - 1]
	if next_level_scene:
		await spawn_level(next_level_scene)

func spawn_level(level_scene: PackedScene):
	var level_instance = level_scene.instantiate()
	var children_to_spawn = level_instance.get_children()
	for child in children_to_spawn:
		level_instance.remove_child(child)
	
	level_instance.position = level_position
	base_level_node.add_child(level_instance)
	
	await _spawn_children_with_delay(level_instance, children_to_spawn)

func _spawn_children_with_delay(level_instance: Node, children_to_spawn: Array) -> void:
	for child in children_to_spawn:
		if is_instance_valid(child):
			await get_tree().create_timer(spawn_delay).timeout
			level_instance.add_child(child)  # Add each child back to the scene tree incrementally

func despawn_level(level_instance: Node) -> void:
	var children_to_despawn = level_instance.get_children()
	await _despawn_children_with_delay(level_instance, children_to_despawn)

	if is_instance_valid(level_instance):
		level_instance.queue_free()
		print("Level fully despawned.")

func _despawn_children_with_delay(level_instance: Node, children_to_despawn: Array) -> void:
	for child in children_to_despawn:
		if is_instance_valid(child):
			await get_tree().create_timer(spawn_delay).timeout
			child.queue_free()
			print("Despawned:", child.name)
	print("All children despawned.")
