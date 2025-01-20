extends Node3D

#UI
const PAUSE_MENU = preload("res://scenes/UI/pause_menu.tscn")
@onready var pause_menu: Node = null
var is_game_paused: bool = false

const Start = preload("res://scenes/Environment/goal.tscn")
const WIND_AMBIENCE_14720 = preload("res://assets/wind-ambience-14720.mp3")
@onready var player_w: CharacterBody3D = $Player_W
@onready var player_b: CharacterBody3D = $Player_B
var goal_node
var in_goal := false
var lock_goal := false
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
	
	if not goal_node: 
		connect_goal()

func _on_level_spawned() -> void:
	#if is_respawning:
		#connect_goal()
		#is_respawning = false
	unfreeze_player(player_w)
	unfreeze_player(player_b)

func _on_entered_goal() -> void:
	if lock_goal: return
	in_goal = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Goal)
	$camera_pivot.in_goal = true
	goal_node._move()
	LevelManager.level_up()
	set_player_spawn_pos_by_level(LevelManager.level)

func _on_exited_goal() -> void:
	if not in_goal or lock_goal: return
	in_goal = false
	AudioManager.fade_out_audio(SoundEffect.SOUND_EFFECT_TYPE.Goal)
	LevelManager.despawn_old_level()
	$camera_pivot.in_goal = false
	disconnect_start()
	connect_goal()
	update_player_fall_threshold()


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
		get_tree().paused = true
		
		pause_menu.connect("resume", Callable(self, "unpause_game"))
		pause_menu.connect("restart", Callable(self, "restart"))
		pause_menu.connect("level_select", Callable(self, "select_level"))
		
	is_game_paused = true

func unpause_game() -> void:
	if pause_menu:
		pause_menu.disconnect("resume", Callable(self, "unpause_game"))
		pause_menu.disconnect("restart", Callable(self, "restart"))
		pause_menu.disconnect("level_select", Callable(self, "select_level"))
		
		pause_menu.queue_free()
		get_tree().paused = false
		pause_menu = null
	is_game_paused = false

func restart() -> void:
	select_level(LevelManager.level)

func select_level(level_given: int) -> void:
	handle_goal_lock(level_given)
	if in_goal:
		in_goal = false
		$camera_pivot.in_goal = false
		AudioManager.fade_out_audio(SoundEffect.SOUND_EFFECT_TYPE.Goal)
		disconnect_goal(LevelManager.level-1)
	else:
		disconnect_goal(LevelManager.level)
	
	freeze_player(player_w)
	freeze_player(player_b)
	LevelManager.total_despawn_level()
	await get_tree().create_timer(0).timeout
	open_level(level_given)
	unpause_game()

func handle_goal_lock(level_given: int) -> void:
	if level_given != LevelManager.level -1: return
	lock_goal = true
	# Create and configure the timer
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", Callable (self, "_on_timer_timeout"))
	timer.start()

func _on_timer_timeout():
	lock_goal = false
	goal_node.reset()
#UI ----------------------------------------------------------------- pause menu
#UI ----------------------------------------------------------------- pause menu
func disconnect_goal(level:int) -> void:
	goal_node = get_node("Level/Level%s/Goal" % level)
	goal_node.disconnect("entered_goal", Callable(self, "_on_entered_goal"))
	goal_node.disconnect("exited_goal", Callable(self, "_on_exited_goal"))
	goal_node = null

func connect_goal() -> void:
	goal_node = get_node("Level/Level%s/Goal" % LevelManager.level)
	goal_node.connect("entered_goal", Callable(self, "_on_entered_goal"))
	goal_node.connect("exited_goal", Callable(self, "_on_exited_goal"))

func disconnect_start() -> void:
	if goal_node:
		goal_node.disconnect("entered_goal", Callable(self, "_on_entered_goal"))
		goal_node.disconnect("exited_goal", Callable(self, "_on_exited_goal"))

func update_player_fall_threshold() -> void:
	player_w.fall_threshold = player_w.fall_threshold + LevelManager.level_position.y
	
	player_b.fall_threshold = player_b.fall_threshold + LevelManager.level_position.y

func set_player_spawn_pos_by_level(level: int) -> void:
	player_w.spawn_position = start_position_list[level-1] + Vector3(0.3, 1.5, 0) + LevelManager.level_position
	
	player_b.spawn_position = start_position_list[level-1] + Vector3(-0.3, 1.5, 0) + LevelManager.level_position

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
