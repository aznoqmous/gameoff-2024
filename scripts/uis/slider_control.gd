extends Node

@export var audio_bus: String;
@onready var h_slider: HSlider = $HBoxContainer/HSlider
@onready var label: Label = $HBoxContainer/Label

var bus;

func _ready() -> void:
	bus = AudioServer.get_bus_index(audio_bus)
	label.text = audio_bus
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	h_slider.value_changed.connect(update)
	
func update(value: float):
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
