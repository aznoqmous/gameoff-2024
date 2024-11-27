extends Node

@onready var button: Button = $CanvasLayer/CenterContainer/VBoxContainer/Button
@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var play_audio: AudioStreamPlayer = $PlayAudio
@onready var move_audio: AudioStreamPlayer = $MoveAudio
@onready var player_container: Node2D = $CanvasLayer/Node2D
@onready var animation_player: AnimationPlayer = $CanvasLayer/Node2D/Player/AnimationPlayer
@onready var player: Node2D = $CanvasLayer/Node2D/Player

var is_falling = true

func _input(event):
	if not is_falling and event is InputEventMouseButton and event.is_pressed():
		move_audio.play()
		animation_player.play("Move")
		await animation_player.animation_finished
		animation_player.play("Idle")

var ySpeed = 200.0
func _ready() -> void:
	button.pressed.connect(play)
		
func _process(delta: float) -> void:
	parallax_layer.motion_offset.x += delta * 10
	
	ySpeed = lerp(ySpeed, 200.0 if is_falling else 1.0, delta * 10)
	parallax_layer.motion_offset.y -= delta * 5 * ySpeed
	
	player.position.x = get_viewport().size.x / 2
	player.position.y = get_viewport().size.y / 2 + 127
	
func play():
	play_audio.play()
	SceneManager.load_game()

func play_fall():
	animation_player.play("Cast")
	
func stop_fall():
	is_falling = false
	animation_player.play("Move")
	await animation_player.animation_finished
	animation_player.play("Idle")
