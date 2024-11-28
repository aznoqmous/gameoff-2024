extends Node2D

@export var symbol : AltarSymbol

@onready var area_2d: Area2D = $Area2D
@onready var game: Game = $".."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $Audio

func _ready() -> void:
	area_2d.area_entered.connect(play_teleport)

func reset_animation():
	animation_player.play("idle")
	
func play_teleport(area: Area2D):
	game.player.prevent_inputs = true
	audio.play()
	animation_player.play("teleport")

func teleport():
	game.handle_altar_teleport()
	await get_tree().create_timer(1).timeout
	if symbol: symbol.activate()
	else: game.player.prevent_inputs = false
