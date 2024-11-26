class_name TheEnd
extends Spell

func _perform(trail: Array):
	print("lol !")

func is_available()->bool:
	return game.is_end_level
