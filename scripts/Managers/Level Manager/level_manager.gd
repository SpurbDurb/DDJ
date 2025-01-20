extends Node
signal level_spawned

const LEVELS = preload("res://scenes/Level/Level System/levels.tres")
var level := 0
var level_position := Vector3.ZERO
var level_up_offset := 15.0
var base_level_node : Node
var new_level_instance : Node
#var spawn_delay := 0

func init() -> void:
	base_level_node = get_tree().root.get_node("Base/Level")
	reset()

func reset() -> void:
	level_position = Vector3.ZERO

func level_up():
	level_position.y += level_up_offset
	spawn_level(level + 1)

func spawn_level(new_level: int):
	if new_level > LEVELS.level_list.size(): return
	
	level = new_level
	var level_scene = LEVELS.level_list[level - 1]
	if not level_scene: return
	
	if new_level_instance:
		SignalManager.clean_all_connections()
	
	new_level_instance = level_scene.instantiate()
	new_level_instance.position = level_position
	base_level_node.add_child(new_level_instance)
	emit_signal("level_spawned")

func despawn_old_level():
	var level_to_despawn = level -1
	var old_level_instance = base_level_node.get_node("Level%s" % level_to_despawn)
	
	var goal_node = old_level_instance.get_node_or_null("Goal")
	if is_instance_valid(goal_node):
		var global_transform = goal_node.global_transform
		old_level_instance.remove_child(goal_node)
		goal_node.name = "Start"
		new_level_instance.add_child(goal_node)
		goal_node.global_transform = global_transform
	
	old_level_instance.queue_free()

func total_despawn_level():
	var level_instance = base_level_node.get_node("Level%s" % level)
	level_instance.queue_free()

func respawn_level() -> void:
	var level_instance = base_level_node.get_node("Level%s" % level)
	level_instance.queue_free()
	await get_tree().create_timer(0).timeout
	# Defer the spawning to the next frame
	call_deferred("spawn_level", level)
