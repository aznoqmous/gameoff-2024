class_name AltarSymbol
extends Node2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sprite_2d: Sprite2D = $Sprite2D

signal on_activate

var state = false

func _ready():
	sprite_2d.modulate.a = 0
	point_light_2d.energy = 0
	sprite_2d.position = Vector2.UP * 100

func _process(delta: float) -> void:
	if state: 
		sprite_2d.modulate.a = lerp(sprite_2d.modulate.a, 1.0, delta)
		point_light_2d.energy = lerp(point_light_2d.energy, 0.2, delta)
		sprite_2d.position = sprite_2d.position.lerp(Vector2.ZERO, delta)

func is_active():
	return state

func activate():
	state = true
	emit_signal("on_activate")
