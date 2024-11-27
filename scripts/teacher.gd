class_name Teacher
extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var game: Game = $"../.."
@onready var dialog_box: DialogBox = $DialogBox
@onready var show_spell: Node2D = $ShowSpell
@onready var greeting_audio: AudioStreamPlayer2D = $GreetingAudio
@onready var bye_audio: AudioStreamPlayer2D = $ByeAudio

@export_multiline var greeting_text : String
@export_multiline var goodbye_text : String

func _ready() -> void:
	area_2d.area_entered.connect(handle_area_enter)
	area_2d.area_exited.connect(handle_area_exit)
	position = (position / game.tileSize).round() * game.tileSize
	modulate = Color.TRANSPARENT
	
	if show_spell != null: show_spell.modulate.a = 0

func handle_area_enter(area: Area2D):
	dialog_box.set_text(greeting_text)
	if greeting_audio: greeting_audio.play()
	
func handle_area_exit(area: Area2D):
	if greeting_audio: greeting_audio.play()
	var ended = await dialog_box.set_text(goodbye_text)
	await get_tree().create_timer(1).timeout
	if dialog_box.target_text == goodbye_text: dialog_box.set_text("")
	
func _process(delta: float) -> void:
	if global_position.distance_to(game.player.position) < game.tileSize * game.player.sightRadius:
		modulate = lerp(modulate, Color.WHITE, delta * 2)
	else:
		modulate = lerp(modulate, Color.TRANSPARENT, delta * 2)
		
	if show_spell:
		show_spell.modulate.a = lerp(show_spell.modulate.a, 0.0 if area_2d.get_overlapping_areas().size() <= 0 else 1.0, delta * 5)

func _input(event):
	pass
