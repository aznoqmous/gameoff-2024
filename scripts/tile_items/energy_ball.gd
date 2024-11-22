class_name EnergyBall
extends TileItem

func _ready() -> void:
	on_movement.connect(handle_movement)

var currentDirection : Vector2 = Vector2.ZERO
var distance = 6
var moved = 0
func push(direction: Vector2):
	moved = 0
	fallable = false
	currentDirection = (direction / game.tileSize).sign()
	handle_movement(currentPosition)

func handle_movement(pos: Vector2):
	moved += 1
	if moved >= distance or game.is_blocked(currentPosition/game.tileSize + currentDirection): 
		fallable = true
		return
	set_target_position(currentPosition + currentDirection * game.tileSize)
