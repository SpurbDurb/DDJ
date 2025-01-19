extends Node3D

#UI
const PAUSE_MENU = preload("res://scenes/UI/pause_menu.tscn")
@onready var pause_menu: Node = null
var is_game_paused: bool = false
var is_respawning: bool = false

const Start = preload("res://scenes/Environment/goal.tscn")
const WIND_AMBIENCE_14720 = preload("res://assets/wind-ambience-14720.mp3")
@onready var player_w: CharacterBody3D = $Player_W
@onready var player_b: CharacterBody3D = $Player_B
var goal_node
var start_position_list = [Vector3(2, 0, 0.5), Vector3(-2.753, -0.3, -2.285), Vector3(-2.753, -0.3, 0.733082)]

func _ready() -> void:
	LevelManager.init()
	LevelManager.connect("level_spawned", Callable(self, "_on_level_spawned"))
	AudioManager.play_music(WIND_AMBIENCE_14720, "sfx_alt2", -10, 10)
	
	open_level(1)

func open_level(level:int) -> void:
	freeze_player(player_w)
	freeze_player(player_b)
	
	LevelManager.spawn_level(level)
	set_player_spawn_pos_by_level(level)
	respawn_players()
	if level != 1:
		spawn_start(level)
	
	if not goal_node: connect_goal()

func _on_level_spawned() -> void:
	if is_respawning:
		connect_goal()
		is_respawning = false
	unfreeze_player(player_w)
	unfreeze_player(player_b)

func _on_entered_goal() -> void:
	$camera_pivot.in_goal = true
	goal_node._move()
	LevelManager.level_up()
	update_spawn_pos()

func _on_exited_goal() -> void:
	LevelManager.despawn_level()
	$camera_pivot.in_goal = false
	disconnect_start()
	connect_goal()


#UI ----------------------------------------------------------------- pause menu
#UI ----------------------------------------------------------------- pause menu
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): # Default key for ESC is "ui_cancel"
		if is_game_paused:
			unpause_game()
		else:
			pause_game()

func pause_game() -> void:
	if not pause_menu:
		pause_menu = PAUSE_MENU.instantiate()
		get_tree().root.add_child(pause_menu)
		
		pause_menu.connect("resume", Callable(self, "unpause_game"))
		pause_menu.connect("restart", Callable(self, "restart"))
		
	is_game_paused = true

func unpause_game() -> void:
	if pause_menu:
		pause_menu.disconnect("resume", Callable(self, "unpause_game"))
		pause_menu.disconnect("restart", Callable(self, "restart"))
		
		pause_menu.queue_free()
		pause_menu = null
	is_game_paused = false

func restart() -> void:
	is_respawning = true
	disconnect_goal()
	freeze_player(player_w)
	freeze_player(player_b)
	LevelManager.respawn_level()
	respawn_players()
#UI ----------------------------------------------------------------- pause menu
#UI ----------------------------------------------------------------- pause menu

func disconnect_goal() -> void:
	goal_node = get_node("Level/Level%s/Goal" % LevelManager.level)
	goal_node.disconnect("entered_goal", Callable(self, "_on_entered_goal"))
	goal_node.disconnect("exited_goal", Callable(self, "_on_exited_goal"))

func connect_goal() -> void:
	goal_node = get_node("Level/Level%s/Goal" % LevelManager.level)
	goal_node.connect("entered_goal", Callable(self, "_on_entered_goal"))
	goal_node.connect("exited_goal", Callable(self, "_on_exited_goal"))

func disconnect_start() -> void:
	if goal_node:
		goal_node.disconnect("entered_goal", Callable(self, "_on_entered_goal"))
		goal_node.disconnect("exited_goal", Callable(self, "_on_exited_goal"))

func update_spawn_pos() -> void:
	player_w.spawn_position = goal_node.target_position + Vector3(0.3, 1.5, 0) 
	player_b.spawn_position = goal_node.target_position + Vector3(-0.3, 1.5, 0)

func set_player_spawn_pos_by_level(level: int) -> void:
	player_w.spawn_position = start_position_list[level-1] + Vector3(0.3, 1.5, 0) 
	player_b.spawn_position = start_position_list[level-1] + Vector3(-0.3, 1.5, 0)

func respawn_players() -> void:
	player_w.spawn_player()
	player_b.spawn_player()

func spawn_start(level) -> void:
	var start_instance = Start.instantiate()
	start_instance.name = "Start"
	start_instance.lock = true
	start_instance.position = start_position_list[level-1]
	LevelManager.new_level_instance.add_child(start_instance)

func freeze_player(player: Node) -> void:
	if player.has_method("set_physics_process"):
		player.set_physics_process(false)  # Disable physics processing
	if player.has_method("set_process"):
		player.set_process(false)  # Disable general processing

func unfreeze_player(player: Node) -> void:
	if player.has_method("set_physics_process"):
		player.set_physics_process(true)  # Enable physics processing
	if player.has_method("set_process"):
		player.set_process(true)  # Enable general processing
