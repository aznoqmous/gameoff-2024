class_name BaseEnvironment
extends Node2D

@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var cloud_sprite: Sprite2D = $ParallaxBackground/ParallaxLayer/CloudSprite
@onready var background_sprite: Sprite2D = $ParallaxBackground/BackgroundLayer/BackgroundSprite

func _ready():
	lerp_alpha(0.0, 1.0)
	
func _process(delta):
	parallax_layer.motion_offset += Vector2(20, -10) * delta

func lerp_alpha(alpha: float, delta: float):
	modulate.a = lerp(modulate.a, alpha, delta)
	if cloud_sprite: cloud_sprite.modulate.a = lerp(cloud_sprite.modulate.a, alpha, delta)
	if background_sprite: background_sprite.modulate.a = lerp(background_sprite.modulate.a, alpha, delta)
