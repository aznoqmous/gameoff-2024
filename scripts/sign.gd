extends Area2D

@export_multiline var message: String;
@export var symbol_sprite_texture : Texture;
@onready var label: Label = $Container/Label
@onready var symbol_sprite: Sprite2D = $Container/SymbolSprite
@onready var container: Node2D = $Container
var state: float = 0

func _ready() -> void:
	area_entered.connect(handle_area_entered)
	area_exited.connect(handle_area_exited)
	label.text = message
	symbol_sprite.texture = symbol_sprite_texture

func _process(delta: float) -> void:
	label.modulate.a = lerp(label.modulate.a, state, delta * 5)
	symbol_sprite.scale = lerp(symbol_sprite.scale, Vector2.ONE * state, delta * 5)

func handle_area_entered(area: Area2D):
	state = 1
func handle_area_exited(area: Area2D):
	state = 0
# ↖↗↙↘←↑→↓
