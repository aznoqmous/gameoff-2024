class_name DialogBox
extends Control

@onready var label: Label = $MarginContainer/Label

func set_text(text: String):
	label.text = ""
	for char in text:
		label.text += char
		if char == " ": await wait(0.05)
		elif char == ".": await wait(0.2)
		elif char == ",": await wait(0.1)
		else: await wait(0.02)
		if label.text.length() <= 0 : return
	label.text = text

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
