class_name Jump
extends Spell

var spell = "Jump"

func _perform(trail: Array):
	player.move(player.lastDirection * 2);
