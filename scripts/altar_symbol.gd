class_name AltarSymbol
extends Node2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer2D = $Audio

signal on_activate(symbol: AltarSymbol)

var state = false

func _ready():
	sprite_2d.modulate.a = 0
	point_light_2d.energy = 0
	#sprite_2d.position = Vector2.UP * 100
	point_light_2d.position = Vector2.UP * 100

func is_active():
	return state

func activate():
	state = true
	emit_signal("on_activate", self)

func play_animation():
	if audio: audio.play()

	var tween = get_tree().create_tween()
	#tween.set_parallel()
	point_light_2d.position = Vector2.UP * 200
	tween.tween_property(point_light_2d, "energy", 0.3, 1)
	tween.tween_property(point_light_2d, "position", Vector2.ZERO, 1.5)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(point_light_2d, "energy", 0.1, 1)
	await tween.finished

	tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(point_light_2d, "energy", 1, 2)
	tween.tween_property(point_light_2d, "texture_scale", 5, 2)
	await tween.finished

	tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(point_light_2d, "energy", 0.1, 1)
	tween.tween_property(sprite_2d, "modulate:a", 1.0, 3)

	await tween.finished
