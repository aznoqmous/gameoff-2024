extends Node
@onready var screen_overlay: ScreenOverlay = $ScreenOverlay

@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
func _process(delta: float) -> void:
	parallax_layer.motion_offset.x += delta * 10
	parallax_layer.motion_offset.y -= delta * 5
