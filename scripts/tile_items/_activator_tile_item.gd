class_name ActivatorTileItem
extends TileItem

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var active : bool = false

func update_state():
	if not active : animated_sprite_2d.play("default")
	else: animated_sprite_2d.play("activated")
	
func set_active(state: bool):
	active = state
	update_state()
