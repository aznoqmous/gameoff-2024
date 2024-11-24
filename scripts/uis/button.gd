class_name CustomButton
extends Control

func _ready():
	gui_input.connect(handle_gui_input)
	
func handle_gui_input(event: InputEvent):
	print(event)
