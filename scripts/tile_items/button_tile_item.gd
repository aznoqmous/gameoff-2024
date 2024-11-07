class_name ButtonTileItem
extends TileItem

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(handle_enter)
	area_2d.area_exited.connect(handle_exit)
	pass # Replace with function body.

var active : bool = false
func handle_enter(area: Area2D):
	active = true
	pass

func handle_exit(area: Area2D):
	active = false
	pass

func _process(delta: float) -> void:
	pass
