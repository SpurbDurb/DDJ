extends Control
signal restart
signal resume
signal level_select(level_id: int)

var on_pause_menu := true
var on_level_menu := false
var on_settings_menu := false

func _ready():
	for button in $L_ButtonContainer/VBoxContainer.get_children():
		button.connect("pressed", Callable(self, "_on_level_pressed").bind(String(button.get_name())))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if on_level_menu or on_settings_menu:
			on_pause_menu = true
			on_level_menu = false
			on_settings_menu = false
			switch_menu()
		else:
			emit_signal("resume")

func _on_restart_pressed() -> void:
	emit_signal("restart")

func _on_main_menu_pressed() -> void:
	queue_free()
	get_tree().paused = false
	LevelManager.level = 1
	SceneManager.switch_scene("res://scenes/UI/main_menu.tscn")

func _on_settings_pressed() -> void:
	on_settings_menu = true
	on_pause_menu = false
	on_level_menu = false
	switch_menu()

func _on_levels_pressed() -> void:
	on_settings_menu = false
	on_pause_menu = false
	on_level_menu = true
	switch_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_level_pressed(button_name: String) -> void:
	var button_level = int(button_name)
	emit_signal("level_select", button_level)

func switch_menu() -> void:
	$PanelContainer.visible = on_pause_menu
	$ButtonContainer.visible = on_pause_menu
	$L_PanelContainer.visible = on_level_menu
	$L_ButtonContainer.visible = on_level_menu
	$S_PanelContainer.visible = on_settings_menu
	$S_ButtonContainer.visible = on_settings_menu
