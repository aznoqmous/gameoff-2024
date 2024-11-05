class_name Tile
extends Node2D

@onready var player: Player = $"../../Player"
@onready var game: Game = $"../.."

var size = 0
var memory = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2.ZERO
	player.on_movement.connect(update_memory)
	update_memory(player.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not position.distance_to(player.position) < game.tileSize * player.sightRadius:
		memory -= delta
	
	if memory > 0:
		size = 1 + sin(Time.get_ticks_msec()/5000.0 * 2 * PI + position.x + position.y) / 20
	else:
		memory = 0
		size = 0
	scale = lerp(scale, Vector2.ONE * size, delta * 10)
	pass

func bump():
	scale = Vector2.ONE * 0.5

func update_memory(playerPosition: Vector2):
	if position.distance_to(player.position) < game.tileSize * player.sightRadius:
		memory += 1
	
