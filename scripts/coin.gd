class_name Coin
extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var game: Game = $"/root/Game"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var loot_particles: CPUParticles2D = $LootParticles

func _ready() -> void:
	if not game or game.collected_coins.has(global_position): return queue_free()
	if game: game.register_coin(self)
	area_2d.area_entered.connect(collect)
	scale = Vector2.ZERO
	
func _process(delta: float):
	handle_animation(delta)

var visibility = false
func handle_animation(delta):
	if visibility: return
	if not game.player: return
	if global_position.distance_to(game.player.global_position) < game.tileSize * game.player.sightRadius:
		visibility = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2.ONE, 1)

func collect(area: Area2D):
	game.collect(self)
	animation_player.play("loot")
