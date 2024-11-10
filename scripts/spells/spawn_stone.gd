class_name SpawnStone
extends Spell

var stone = preload("res://scenes/items/stone.tscn")

func _perform(trail: Array):
	var spawnPoint = player.cast_line.get_points()[0] / game.tileSize
	var newStone : Stone = stone.instantiate()
	game.add_item(newStone, spawnPoint)
