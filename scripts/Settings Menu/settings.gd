extends Control




func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)


func _on_mute_master_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on )


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	
	
func _on_mute_music_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1, toggled_on )


func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)


func _on_mute_sfx_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2, toggled_on )
