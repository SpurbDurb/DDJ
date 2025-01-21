extends Control

func _on_main_menu_pressed() -> void:
	queue_free()
	get_tree().paused = false
	LevelManager.level = 1
	SceneManager.switch_scene("res://scenes/UI/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
