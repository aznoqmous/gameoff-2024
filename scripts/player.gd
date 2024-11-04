class_name Player
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if not targetPositions.is_empty():
		var targetPosition = targetPositions[0]
		position = lerp(position, targetPosition, delta * 20)
		if position.distance_to(targetPosition) < 10:
			position = targetPosition
			currentPosition = targetPosition
			targetPositions.pop_front()
	pass

var currentPosition = Vector2(0,0)
var targetPositions : Array
func move(direction: Vector2):
	var pos = currentPosition
	if not targetPositions.is_empty():
		pos = targetPositions[-1]
	targetPositions.append(pos + direction)
	
	print(targetPositions.size())
