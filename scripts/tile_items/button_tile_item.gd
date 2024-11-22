class_name ButtonTileItem
extends ActivatorTileItem

@onready var area_2d: Area2D = $Area2D
@onready var enter_audio: AudioStreamPlayer2D = $EnterAudio
@onready var exit_audio: AudioStreamPlayer2D = $ExitAudio

func _ready() -> void:
	set_active(area_2d.get_overlapping_areas().size() > 0)
	area_2d.area_entered.connect(handle_enter)
	area_2d.area_exited.connect(handle_exit)

func handle_enter(area: Area2D):
	set_active(area_2d.get_overlapping_areas().size() > 0)
	enter_audio.play()

func handle_exit(area: Area2D):
	set_active(area_2d.get_overlapping_areas().size() > 0)
	exit_audio.play()
