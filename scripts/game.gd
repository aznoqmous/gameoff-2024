class_name Game
extends Node2D

@onready var player: Player = $Player
@onready var terrain: Node2D = $Terrain
@onready var ground_layer: TileMapLayer = $GroundLayer
@export var mapSize = Vector2(10,10)
@export var tileSize = 100
var tiles = {}


# Called when the node enters the scene tree for the first $Terraintime.
func _ready() -> void:
	create_map()

	player.on_movement.connect(handle_player_movement)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	var direction = null
	if event.is_action_pressed("MoveRight"):
		direction = Vector2(1, 0)
	if event.is_action_pressed("MoveLeft"):
		direction = Vector2(-1, 0)
	if event.is_action_pressed("MoveUp"):
		direction = Vector2(0, -1)
	if event.is_action_pressed("MoveDown"):
		direction = Vector2(0, 1)
	
	if direction:
		var playerPosition = player.get_last_position() / tileSize + direction
		var tile = get_tile(playerPosition.x, playerPosition.y)
		if tile:
			tile.bump()
			player.move(direction * tileSize)

var baseTile = preload("res://scenes/tile.tscn")
func create_map() -> void:
	ground_layer.visible = false
	for tilePosition in ground_layer.get_used_cells():
		var newTile: Tile = baseTile.instantiate()
		print(tilePosition.x, " ", tilePosition.y, " ", newTile)
		newTile.position = tilePosition * tileSize
		terrain.add_child(newTile)
		set_tile(tilePosition.x, tilePosition.y, newTile)
			

func get_tile(x, y) -> Tile:
	var key = Vector2(x,y)
	if tiles.has(key):
		return tiles[key]
	return null

func set_tile(x, y, tile) -> void:
	tiles[Vector2(x,y)] = tile

func handle_player_movement(playerPosition: Vector2):
	print("PLAYER MOVED", playerPosition)

	
