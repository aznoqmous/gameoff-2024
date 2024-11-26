class_name SceneManagerProgress
extends CanvasLayer

@onready var progress_container: Panel = $Panel/ProgressContainer
@onready var progress_value: Panel = $Panel/ProgressContainer/ProgressValue
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target_progress = 0.0

func set_progress(value: float):
	target_progress = value
	if value == 0.0: 
		progress_value.size.x = 0

func _process(delta: float) -> void:
		progress_value.size.x = lerp(progress_value.size.x, target_progress * progress_container.size.x, delta * 5)

func appear():
	animation_player.play("Appear")
	await animation_player.animation_finished

func disappear():
	animation_player.play("Disappear")
	await animation_player.animation_finished
	print("finished")
