class_name SpawnEnergyBall
extends Spell

var energy_ball = preload("res://scenes/items/energy_ball.tscn")
var instance: EnergyBall = null

func _perform(trail: Array):
	if not instance == null: instance.fall()
	var spawnPoint = player.cast_line.get_points()[0] / game.tileSize
	var newEnergyBall : EnergyBall = energy_ball.instantiate()
	instance = newEnergyBall
	game.add_item(newEnergyBall, spawnPoint)
