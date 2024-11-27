extends Node

@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	parallax_layer.motion_offset.x += delta * 10
	parallax_layer.motion_offset.y -= delta * 5
