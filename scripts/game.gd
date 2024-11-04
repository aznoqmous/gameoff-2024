class_name Game
extends Node2D

@onready var player: Player = $Player
@onready var terrain: Node2D = $Terrain
@export var mapSize = Vector2(10,10)
@export var tileSize = 100
var tiles = {}


# Called when the node enters the scene tree for the first $Terraintime.
func _ready() -> void:
	create_map()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("MoveRight"):
		player.move(Vector2(tileSize, 0))
	if event.is_action_pressed("MoveLeft"):
		player.move(Vector2(-tileSize, 0))
	if event.is_action_pressed("MoveUp"):
		player.move(Vector2(0, -tileSize))
	if event.is_action_pressed("MoveDown"):
		player.move(Vector2(0, tileSize))

func create_map() -> void:
	var tile = load("res://scenes/tile.tscn")
	
	for x in mapSize.x:
		for y in mapSize.y:
			print(x, " ", y)
			var newTile = tile.instantiate()
			newTile.position.x = x * tileSize
			newTile.position.y = y * tileSize
			terrain.add_child(newTile)
