extends Node

signal level_spawned

const LEVELS = preload("res://scripts/Managers/Level Manager/levels.tres")
var level := 1
var level_position := Vector3.ZERO
var level_up_offset := 15.0
var spawn_delay := 0
var base_level_node
var new_level_instance

func _ready() -> void:
	base_level_node = get_tree().root.get_node("Base/Level")

func level_up():
	level_position.y += level_up_offset
	quick_spawn_level(level + 1)

func quick_spawn_level(new_level: int):
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

func quick_despawn_level():
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

#func spawn_level(new_level: int):
	#if new_level > LEVELS.level_list.size(): return
	#
	#level = new_level
	#var level_scene = LEVELS.level_list[level - 1]
	#
	#if level_scene:
		#await spawn(level_scene)
#
#func despawn_level():
	#var level_to_despawn = level -1
	#var despawn_node = base_level_node.get_node("Level%s" % level_to_despawn)
	#await despawn(despawn_node)
	
#func spawn(level_scene: PackedScene):
	#new_level_instance = level_scene.instantiate()
	#var children_to_spawn = new_level_instance.get_children()
	#for child in children_to_spawn:
		#new_level_instance.remove_child(child)
	#
	#base_level_node.add_child(new_level_instance)
	#new_level_instance.global_transform.origin = level_position
	#
	#await _spawn_children_with_delay(children_to_spawn)
	#emit_signal("level_spawned")

#func _spawn_children_with_delay(children_to_spawn: Array) -> void:
	#for child in children_to_spawn:
		#if is_instance_valid(child):
			#await get_tree().create_timer(spawn_delay).timeout
			#new_level_instance.add_child(child)
#
#func despawn(old_level_instance: Node) -> void:
	#var children_to_despawn = old_level_instance.get_children()
	#await _despawn_children_with_delay(old_level_instance, children_to_despawn)
#
	#if is_instance_valid(old_level_instance):
		#old_level_instance.queue_free()
#
#func _despawn_children_with_delay(old_level_instance: Node, children_to_despawn: Array) -> void:
	#for child in children_to_despawn:
		#if is_instance_valid(child) and child.name != "Goal":
			#pass
			#await get_tree().create_timer(spawn_delay).timeout
			#child.queue_free()
		#elif is_instance_valid(child):
			#var global_transform = child.global_transform
			#old_level_instance.remove_child(child)
			#child.name = "Start"
			#new_level_instance.add_child(child)
			#child.global_transform = global_transform
