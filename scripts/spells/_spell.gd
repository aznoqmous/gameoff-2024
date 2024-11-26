class_name Spell
extends Node

@onready var player: Player = $"../.."
@onready var game: Game = $"../../.."
@onready var audio: AudioStreamPlayer = $Audio

func is_available()->bool:
	return true

func cast(trail: Array):
	if audio: audio.play()
	_perform(trail)

func _perform(trail: Array): pass
