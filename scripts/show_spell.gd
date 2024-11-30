extends Node2D

@onready var line_2d: Line2D = $Line2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var points = []

func _ready():
	points = line_2d.points.duplicate()
	var line2d_copy = line_2d.duplicate()
	line2d_copy.modulate.a = 0.5
	add_child(line2d_copy)
	animate()
	
func _process(delta):
	sprite_2d.position = lerp(sprite_2d.position, line_2d.points[-1], delta * 10)
	
func animate():
	if not is_inside_tree(): return
	var tree = get_tree()	
	line_2d.clear_points()
	for point in points:
		line_2d.add_point(point)
		await tree.create_timer(0.8).timeout
	
	animate()
