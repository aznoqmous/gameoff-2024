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
	active = true
	animated_sprite_2d.play("activated")
	pass

func handle_exit(area: Area2D):
	active = false
	animated_sprite_2d.play("default")
	pass

func _process(delta: float) -> void:
	pass
