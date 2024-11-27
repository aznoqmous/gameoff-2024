class_name ScreenOverlay
extends CanvasLayer

@onready var panel: Panel = $Panel

func animate(direction=1, transition_duration=1):
	var tween = get_tree().create_tween()
	tween.tween_property(panel, "modulate:a", direction, transition_duration)
	await tween.finished
