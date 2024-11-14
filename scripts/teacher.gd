class_name Teacher
extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var game: Game = $"../.."
@onready var dialog_box: DialogBox = $DialogBox

@export_multiline var greeting_text : String
@export_multiline var goodbye_text : String

func _ready() -> void:
	area_2d.area_entered.connect(handle_area_enter)
	area_2d.area_exited.connect(handle_area_exit)
	position = (position / game.tileSize).round() * game.tileSize
	modulate = Color.TRANSPARENT

func handle_area_enter(area: Area2D):
	dialog_box.set_text(greeting_text)
	pass
	
func handle_area_exit(area: Area2D):
	dialog_box.set_text("")
	pass
	
func _process(delta: float) -> void:
	if global_position.distance_to(game.player.position) < game.tileSize * game.player.sightRadius:
		modulate = lerp(modulate, Color.WHITE, delta)
	else:
		modulate = lerp(modulate, Color.TRANSPARENT, delta)

func _input(event):
	pass
