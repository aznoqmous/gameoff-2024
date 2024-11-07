class_name Spell
extends Node

@onready var player: Player = $"../.."
@onready var game: Game = $"../../.."

func cast(trail: Array):
	_perform(trail)

func _perform(trail: Array): pass
