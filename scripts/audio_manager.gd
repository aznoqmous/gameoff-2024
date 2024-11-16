extends Node

var themes = {}
@export var fade_in_speed: float
@export var fade_out_speed: float

@onready var background_audio: AudioStreamPlayer = $BackgroundAudio
@onready var theme_audio: AudioStreamPlayer = $ThemeAudio

var theme_volume = 0
var active_theme: AudioStream

var active_player : AudioStreamPlayer
var last_player : AudioStreamPlayer
func _process(delta):
	if active_player: 
		active_player.volume_db = lerp(active_player.volume_db, theme_audio.volume_db, delta * fade_in_speed)
	if last_player: 
		last_player.volume_db = lerp(last_player.volume_db, -80.0, delta * fade_out_speed)

func preload_level_audio(stream: AudioStream):
	if themes.has(stream): return
	var player: AudioStreamPlayer = theme_audio.duplicate()
	player.stream = stream
	themes[stream] = player
	add_child(player)

func play_theme(theme: AudioStream):
	var player = themes[theme]
	if active_player and active_player != player : 
		last_player = active_player
	active_player = player
	player.volume_db = -80
	player.play()
