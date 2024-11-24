extends Node

@onready var button: Button = $CanvasLayer/CenterContainer/Button

func _ready() -> void:
	button.pressed.connect(play)
	pass
	
func play():
	SceneManager.load_game()
