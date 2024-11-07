extends Area2D

@export_multiline var message: String;
@onready var label: Label = $Label
var state: float = 0

func _ready() -> void:
	area_entered.connect(handle_area_entered)
	area_exited.connect(handle_area_exited)
	label.text = message

func _process(delta: float) -> void:
	label.modulate.a = lerp(label.modulate.a, state, delta * 5)

func handle_area_entered(area: Area2D):
	state = 1
func handle_area_exited(area: Area2D):
	state = 0
# ↖↗↙↘←↑→↓
