extends Node

@export var fade_in_duration: float
@export var fade_out_duration: float

@onready var background_audio: AudioStreamPlayer = $BackgroundAudio
@onready var theme_audio: AudioStreamPlayer = $ThemeAudio

var active_theme: AudioStreamPlayer

func play_theme(theme: AudioStream):
	print("active theme", active_theme)
	if active_theme != null: fade_out(active_theme)
	if theme: fade_in(theme)

func fade_out(player: AudioStreamPlayer):
	var tween = get_tree().create_tween()
	tween.tween_property(player, "volume_db", -80, fade_out_duration)
	await tween.finished
	if player != null : player.queue_free()

func fade_in(stream: AudioStream):
	var player: AudioStreamPlayer = theme_audio.duplicate()
	add_child(player)
	player.stream = stream
	player.volume_db = -80
	player.play()
	var tween = get_tree().create_tween()
	tween.tween_property(player, "volume_db", theme_audio.volume_db, fade_in_duration)
	active_theme = player
