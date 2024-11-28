class_name TheEnd
extends Spell

func _perform(trail: Array):
	game.play_end()

func is_available()->bool:
	return game.is_end_level
