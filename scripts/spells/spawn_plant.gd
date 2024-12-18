class_name SpawnPlant
extends Spell


func _perform(trail: Array):
	var spawnPoint = player.cast_line.get_points()[0] / game.tileSize
	var lastPoint = player.cast_line.get_points()[-1] / game.tileSize
	var startPos = get_pos(1, trail)
	var lastPos = get_pos(10, trail)
	
	var origin = spawnPoint
	var targetDirection = startPos
	if not startPos:
		origin = lastPoint
		targetDirection = lastPos

	for i in range(0, 3):
		var pos = origin + targetDirection * (i + 1)
		if game.get_tile_at_position(pos): break
		var newTile = game.add_lilipad_tile(pos)
		game.current_level.objects.append(newTile)
	
func get_pos(value: int, arr: Array):
	var y = 0
	for row in arr:
		var x = 0
		for val in row:
			if val == value: return Vector2(x - 1, y - 1)
			x += 1
		y += 1
	return null
