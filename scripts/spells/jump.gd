class_name Jump
extends Spell

var spell = "Jump"

func _perform(trail: Array):
	var finalPosition
	var finalDirection
	var position = player.get_last_position()
	for step in range(0, (player.lastDirection / game.tileSize).length() * 2 + 1):
		finalDirection = player.lastDirection * step
		finalPosition = (position + finalDirection) / game.tileSize
		if game.is_blocked(finalPosition):
			var tile = game.get_tile_at_position(finalPosition)
			print(tile, tile._item)
			if tile and not tile.push(player.lastDirection): break
	player.move(finalDirection)
