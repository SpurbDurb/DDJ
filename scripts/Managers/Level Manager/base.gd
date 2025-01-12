extends Node3D

#@export var level := 1
@onready var player_w: CharacterBody3D = $Player_W
@onready var player_b: CharacterBody3D = $Player_B
var goal_node

func _ready() -> void:
	LevelManager.init()
	LevelManager.connect("level_spawned", Callable(self, "_on_level_spawned"))
	#temp
	open_level(1)

func open_level(level:int) -> void:
	#maybe reset LevelManager? so its spawn in (0,0,0)
	freeze_player(player_w)
	freeze_player(player_b)
	
	LevelManager.quick_spawn_level(level)
	
	if not goal_node: connect_to_goal()

func _on_level_spawned() -> void:
	unfreeze_player(player_w)
	unfreeze_player(player_b)

func _on_entered_goal() -> void:
	$camera_pivot.in_goal = true
	goal_node._move()
	LevelManager.level_up()
	update_player_spawn_pos()

func _on_exited_goal() -> void:
	LevelManager.quick_despawn_level()
	$camera_pivot.in_goal = false
	disconnect_start()
	connect_to_goal()




func connect_to_goal() -> void:
	goal_node = get_node("Level/Level%s/Goal" % LevelManager.level)
	goal_node.connect("entered_goal", Callable(self, "_on_entered_goal"))
	goal_node.connect("exited_goal", Callable(self, "_on_exited_goal"))

func disconnect_start() -> void:
	if goal_node:
		goal_node.disconnect("entered_goal", Callable(self, "_on_entered_goal"))
		goal_node.disconnect("exited_goal", Callable(self, "_on_exited_goal"))

func update_player_spawn_pos() -> void:
	player_w.spawn_position = goal_node.target_position + Vector3(0.25, 0.5, 0) 
	player_b.spawn_position = goal_node.target_position + Vector3(-0.25, 0.5, 0)

func freeze_player(player: Node) -> void:
	if player.has_method("set_physics_process"):
		player.set_physics_process(false)  # Disable physics processing
	if player.has_method("set_process"):
		player.set_process(false)  # Disable general processing
	if player.has_method("set_freeze_mode"):
		player.set_freeze_mode(true)  # Optional, for custom freeze logic

func unfreeze_player(player: Node) -> void:
	if player.has_method("set_physics_process"):
		player.set_physics_process(true)  # Enable physics processing
	if player.has_method("set_process"):
		player.set_process(true)  # Enable general processing
	if player.has_method("set_freeze_mode"):
		player.set_freeze_mode(false)  # Optional, for custom unfreeze logic
