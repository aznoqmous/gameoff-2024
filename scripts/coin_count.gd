extends CanvasLayer

@onready var game: Game = $"/root/Game"
@onready var label: Label = $HBoxContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_text(coins_text: String):
	label.text = coins_text

func show_coins():
	animation_player.play("show")
	
func update_coins():
	set_text(str(game.collected_coins.size(), "/", game.existing_coins.size()))
