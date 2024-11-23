class_name DialogBox
extends Control

@onready var label: Label = $MarginContainer/Label
var target_text = ""

func set_text(text: String):
	var current_target_text = text
	target_text = text
	label.text = ""
	for char in text:
		if target_text != current_target_text: return false
		label.text += char
		if char == " ": await wait(0.05)
		elif char == ".": await wait(0.2)
		elif char == ",": await wait(0.1)
		else: await wait(0.02)
		if label.text.length() <= 0 : return true
	label.text = text
	return true

func _ready():
	label.text = ""
	pass

func _process(delta: float):
	var targetScale = 0
	if label.text.length() > 0 : targetScale = 1
	scale = lerp(scale, Vector2.ONE * targetScale, delta * 10)
	pass

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
