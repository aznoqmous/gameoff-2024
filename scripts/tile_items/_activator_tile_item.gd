class_name ActivatorTileItem
extends TileItem

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var stay_activated : bool = false
var activated : bool = false

func update_state():
	if not activated : animated_sprite_2d.play("default")
	else: animated_sprite_2d.play("activated")
	
func set_active(state: bool):
	if activated and stay_activated: return;
	activated = state
	update_state()
