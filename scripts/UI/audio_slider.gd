extends HSlider

@export var bus_name: String
var bus_index: int

func _ready() -> void:
	# Get the index of the audio bus
	bus_index = AudioServer.get_bus_index(bus_name)
	# Set the slider value to match the current volume of the bus
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	# Connect the value_changed signal to update the bus volume
	value_changed.connect(_on_value_changed)

func _on_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
