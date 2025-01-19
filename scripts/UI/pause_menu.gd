extends Control
signal resume
signal restart

func _on_resume_pressed() -> void:
	emit_signal("resume")

func _on_restart_pressed() -> void:
	emit_signal("restart")
