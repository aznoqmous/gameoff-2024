class_name ButtonTileItem
extends TileItem

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	area_2d.area_entered.connect(handle_enter)
	area_2d.area_exited.connect(handle_exit)
	pass # Replace with function body.

var active : bool = false
func handle_enter(area: Area2D):
	update_state()

func handle_exit(area: Area2D):
	update_state()
	
func update_state():
	active = area_2d.get_overlapping_areas().size() > 0
	if not active : animated_sprite_2d.play("default")
	else: animated_sprite_2d.play("activated")
