class_name EnvironmentFireFly
extends Node2D

@onready var player : Player = $"../.."

var speed = 200
var rotation_speed = 1
var direction = randf() * 2 * PI

var target_distance = 500 * 2
var max_player_distance = 500 * 4
var target_position: Vector2

var state = false

func _ready() -> void:
	position = new_target_position()
	target_position = new_target_position()
	pass


func _process(delta: float) -> void:
	scale = lerp(scale, Vector2.ONE if state else Vector2.ZERO, delta)

	if state:
		handle_movement(delta)
	else:
		if scale.length() < 0.1:
			global_position = new_target_position()
			state = true

func handle_movement(delta):
	var diff = target_position - position
	if player.position.distance_to(target_position) > max_player_distance:
		state = false
		target_position = new_target_position()
		return
		
	if diff.length() <= target_distance / 10: 
		target_position = new_target_position()
		return
	
	var target_direction = diff.angle()
	direction = lerp_angle(direction, target_direction, delta * rotation_speed)
	position += Vector2.RIGHT.rotated(direction) * delta * speed

func new_target_position():
	return player.position + Vector2.RIGHT.rotated(randf() * 2 * PI) * target_distance

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
