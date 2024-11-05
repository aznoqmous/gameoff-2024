class_name Player
extends Node2D


@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var bodyNode : Node2D = $BodyNode
@export var sightRadius = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationPlayer.play("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if not targetPositions.is_empty():
		var targetPosition = targetPositions[0]
		position = lerp(position, targetPosition, delta * 20)
		targetDirection = sign(currentPosition.x - targetPosition.x)
		if position.distance_to(targetPosition) < 10:
			position = targetPosition
			currentPosition = targetPosition
			targetPositions.pop_front()
			emit_signal("on_movement", currentPosition)
			if not targetPositions.is_empty():
				animationPlayer.stop()
				animationPlayer.play("Move")
			else:
				animationPlayer.play("Idle")
	# look in right direction
	if targetDirection:
		bodyNode.scale.x = lerp(bodyNode.scale.x, targetDirection, delta * 20)
	pass

var targetDirection = null
var currentPosition = Vector2(0,0)
var targetPositions : Array
var lastPosition = null
func move(direction: Vector2):		
	var pos = currentPosition

	if not targetPositions.is_empty():
		pos = targetPositions[-1]
	else:
		animationPlayer.play("Move")

	targetPositions.append(pos + direction)

func get_last_position():
	if not targetPositions.is_empty():
		return targetPositions[-1]
	return currentPosition

signal on_movement(position: Vector2)
