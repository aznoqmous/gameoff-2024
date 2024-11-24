extends CanvasLayer

func _input(event: InputEvent):
	if event.is_action_pressed("Menu"):
		visible = !visible
