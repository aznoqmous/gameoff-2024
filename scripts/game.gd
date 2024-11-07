class_name Game
extends Node2D

@onready var player: Player = $Player
@onready var terrain: Node2D = $Terrain
@onready var stones: Node2D = $Terrain/Stones
@onready var blocks: Node2D = $Terrain/Blocks
@onready var ground_layer: TileMapLayer = $GroundLayer
@export var mapSize = Vector2(10,10)
@export var tileSize = 100
var tiles = {}


# Called when the node enters the scene tree for the first $Terraintime.
func _ready() -> void:
	create_map()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var baseTile = preload("res://scenes/tiles/tile.tscn")
var lilipadBaseTile = preload("res://scenes/tiles/lilipad_tile.tscn")
func create_map() -> void:
	ground_layer.visible = false
	for tilePosition in ground_layer.get_used_cells():
		add_ground_tile(tilePosition)
	
	for stone: TileItem in stones.get_children():
		stone.init()
	for block: TileItem in blocks.get_children():
		block.init()

func add_lilipad_tile(tilePosition: Vector2):
	var newTile : Tile = lilipadBaseTile.instantiate()
	add_tile(newTile, tilePosition)

func add_ground_tile(tilePosition: Vector2):
	var newTile : Tile = baseTile.instantiate()
	add_tile(newTile, tilePosition)
	
func add_tile(tile: Tile, tilePosition: Vector2):
	tile.position = tilePosition * tileSize
	terrain.add_child(tile)
	set_tile(tilePosition.x, tilePosition.y, tile)
	
func get_tile(x, y) -> Tile:
	var key = Vector2(x,y)
	if tiles.has(key):
		return tiles[key]
	return null
	
func get_tile_at_position(pos: Vector2) -> Tile:
	return get_tile(pos.x, pos.y)
func is_walkable(pos: Vector2) -> bool:
	var tile = get_tile_at_position(pos)
	if not tile: return false
	return tile.is_walkable()
func set_tile(x, y, tile) -> void:
	tiles[Vector2(x,y)] = tile

	
