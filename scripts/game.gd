class_name Game
extends Node2D

@onready var player: Player = $Player
@onready var terrain: Node2D = $Terrain
@onready var stones: Node2D = $Terrain/Stones
@onready var blocks: Node2D = $Terrain/Blocks
@onready var items: Node2D = $Terrain/Items
@onready var tilesContainer: Node2D = $Terrain/Tiles

@onready var ground_layer: TileMapLayer = $GroundLayer
@export var mapSize = Vector2(10,10)
@export var tileSize = 100
var tiles = {}

func _ready() -> void:
	create_map()

var baseTile = preload("res://scenes/tiles/tile.tscn")
var lilipadBaseTile = preload("res://scenes/tiles/lilipad_tile.tscn")
func create_map() -> void:	
	for tile: Tile in tilesContainer.get_children(): add_tile(tile, (tile.position/tileSize).round())
	
	ground_layer.visible = false
	for tilePosition in ground_layer.get_used_cells():
		add_ground_tile(tilePosition)
	
	for item: TileItem in items.get_children(): item.init()
	for stone: TileItem in stones.get_children(): stone.init()
	for block: TileItem in blocks.get_children(): block.init()

func add_lilipad_tile(tilePosition: Vector2):
	var newTile : Tile = lilipadBaseTile.instantiate()
	add_tile(newTile, tilePosition)

func add_ground_tile(tilePosition: Vector2):
	var newTile : Tile = baseTile.instantiate()
	add_tile(newTile, tilePosition)
	
func add_tile(tile: Tile, tilePosition: Vector2):
	tile.position = tilePosition * tileSize
	tilesContainer.add_child(tile)
	set_tile(tilePosition.x, tilePosition.y, tile)
	
func add_item(tile_item: TileItem, pos: Vector2):
	items.add_child(tile_item)
	tile_item.position = pos * tileSize
	tile_item.init()
	
func get_tile(x, y) -> Tile:
	var key = Vector2(x,y)
	if tiles.has(key) and tiles[key].is_active():
		return tiles[key]
	return null
	
func get_tile_at_position(pos: Vector2) -> Tile:
	var tile = get_tile(pos.x, pos.y)
	if tile: return tile
	return null	
	
func is_walkable(pos: Vector2) -> bool:
	var tile = get_tile_at_position(pos)
	return tile and tile.is_walkable()
	
func is_blocked(pos: Vector2) -> bool:
	var tile = get_tile_at_position(pos)
	return tile and not tile.is_walkable()

func set_tile(x, y, tile) -> void:
	tiles[Vector2(x,y)] = tile
