class_name SpellSymbol
extends Node2D

@onready var label: Label = $Label
var line : Line2D

func set_opacity(value):
	modulate.a = value

func add_line(line : Line2D):
	add_child(line)

func set_text(text):
	label.text = text
	
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	await tween.finished
	queue_free()
	pass # Replace with function body.

func _process(delta: float) -> void:
	position.y -= delta * 100
	pass
