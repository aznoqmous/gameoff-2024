class_name SpawnTornado
extends Spell

var tornado = preload("res://scenes/items/tornado.tscn")

func _perform(trail: Array):
	var spawnPoint = player.cast_line.get_points()[0] / game.tileSize
	var newStone : Tornado = tornado.instantiate()
	game.add_item(newStone, spawnPoint)
