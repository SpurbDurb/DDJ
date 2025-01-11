extends Node3D

@export var level := 1
@onready var player_w: CharacterBody3D = $Player_W
@onready var player_b: CharacterBody3D = $Player_B
var goal_node

func _ready() -> void:
	#temp
	goal_node = get_node("Level/Level%s/Goal" % level)
	goal_node.connect("entered_goal", Callable(self, "_on_entered_goal"))
	goal_node.connect("exited_goal", Callable(self, "_on_exited_goal"))
	
	
	LevelManager.connect("level_spawned", Callable(self, "_on_level_spawned"))
	
	#freeze_player(player_w)
	#freeze_player(player_b)
	
	#LevelManager.quick_spawn_level(level)

func _on_level_spawned() -> void:
	unfreeze_player(player_w)
	unfreeze_player(player_b)
	
	#goal_node = get_node("Level/Level%s/Goal" % level)
	#goal_node.connect("entered_goal", Callable(self, "_on_entered_goal"))
	#goal_node.connect("exited_goal", Callable(self, "_on_exited_goal"))

func _on_entered_goal() -> void:
	$camera_pivot.in_goal = true
	goal_node._move()
	LevelManager.level_up()

func _on_exited_goal() -> void:
	LevelManager.quick_despawn_level()
	$camera_pivot.in_goal = false

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
