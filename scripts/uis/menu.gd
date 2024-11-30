extends CanvasLayer
@onready var main_menu: Button = $Control/VBoxContainer/HBoxContainer/MainMenu
@onready var close_menu: Button = $Control/VBoxContainer/HBoxContainer/CloseMenu

func _ready() -> void:
	main_menu.pressed.connect(go_to_title_menu)
	close_menu.pressed.connect(close)

func _input(event: InputEvent):
	if event.is_action_pressed("Menu"):
		visible = !visible

func close():
	visible = false
	
func go_to_title_menu():
	SceneManager.load_title()
