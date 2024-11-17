class_name Spell
extends Node

@onready var player: Player = $"../.."
@onready var game: Game = $"../../.."
@onready var audio: AudioStreamPlayer = $Audio

func cast(trail: Array):
	audio.play()
	_perform(trail)

func _perform(trail: Array): pass
