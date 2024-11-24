extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var game: Game = $".."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var symbol : AltarSymbol

func _ready() -> void:
	area_2d.area_entered.connect(play_teleport)

func reset_animation():
	animation_player.play("idle")
	
func play_teleport(area: Area2D):
	animation_player.play("teleport")

func teleport():
	game.player.targetPositions.clear()
	game.player.set_current_position(game.sanctuary.position)

func activate_symbol():
	if symbol: symbol.activate()
