class_name ButtonTileItem
extends ActivatorTileItem

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(handle_enter)
	area_2d.area_exited.connect(handle_exit)

func handle_enter(area: Area2D):
	set_active(area_2d.get_overlapping_areas().size() > 0)

func handle_exit(area: Area2D):
	set_active(area_2d.get_overlapping_areas().size() > 0)
