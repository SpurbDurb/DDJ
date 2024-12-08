extends Node3D

@export_range(1,9) var connection_id: int = 1
var n_buttons := 0
var count := 0
var on := false

func _ready() -> void:
	SignalManager.register_signal(connection_id)
	call_deferred("_deferred_ready")

func _deferred_ready() -> void:
	for child in get_children():
		n_buttons += 1
		child.connect("entered", Callable(self, "_on_button_entered"))
		child.connect("exited", Callable(self, "_on_button_exited"))

func _on_button_entered() -> void:
	count += 1
	if count == n_buttons:
		on = true
		SignalManager.emit_connection_signal(connection_id, self)

func _on_button_exited() -> void:
	count -= 1
	if on and count != n_buttons:
		on = false
		SignalManager.emit_connection_signal(connection_id, self)
