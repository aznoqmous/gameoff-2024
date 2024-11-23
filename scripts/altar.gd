extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var game: Game = $"../.."

func _ready() -> void:
	area_2d.area_entered.connect(teleport)

func teleport(area: Area2D):
	print(game.player)
	game.player.targetPositions.clear()
	game.player.set_current_position(game.sanctuary.position)
