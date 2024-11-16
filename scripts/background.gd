extends Node

@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer

func _process(delta: float) -> void:
	parallax_layer.motion_offset += Vector2(20, -10) * delta
