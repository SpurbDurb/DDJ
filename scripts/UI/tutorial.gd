extends Control
signal okay

func _on_okay_pressed() -> void:
	emit_signal("okay")
