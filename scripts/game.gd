class_name Game
extends Node2D

@onready var audio_manager: Node = $AudioManager
@onready var player: Player = $Player
@onready var terrain: Node2D = $Terrain
@onready var stones: Node2D = $Terrain/Stones
@onready var blocks: Node2D = $Terrain/Blocks
@onready var items: Node2D = $Terrain/Items
@onready var tilesContainer: Node2D = $Terrain/Tiles
@onready var sanctuary: Level = $Sanctuary

@onready var camera_sprite_2d: Sprite2D = $EnvironmentManager/ParallaxBackground/BackgroundLayer/Sprite2D
@onready var environment: EnvironmentManager = $EnvironmentManager

@onready var ground_layer: TileMapLayer = $GroundLayer
@export var mapSize = Vector2(10,10)
@export var tileSize = 100

var current_level:Level = null
var tiles = {}
var levels = []

func _ready() -> void:
	player.on_movement.connect(handle_player_movement)
	create_map()
	handle_player_movement(player.position)


var baseTile = preload("res://scenes/tiles/tile.tscn")
var lilipadBaseTile = preload("res://scenes/tiles/lilipad_tile.tscn")
func create_map() -> void:	
	for tile: Tile in tilesContainer.get_children(): add_tile(tile, (tile.position/tileSize).round())
	
	ground_layer.visible = false
	
	load_tiles_layer(ground_layer)
	for level: Level in levels.duplicate():
		if level.is_visible_in_tree():
			level.init()
			load_level(level.clone())
			remove_child(level)

func load_tiles_layer(layer: TileMapLayer, offset: Vector2 = Vector2.ZERO, level: Level = null):
	
	for tile in layer.get_children():
		tile.reparent(tilesContainer)
		set_tile_at_position((tile.global_position / tileSize).round(), tile)
		if level : 
			tile.set_level(level)
			level.objects.append(tile)

	for tilePosition in layer.get_used_cells():
		var texture : ImageTexture = get_cell_texture(tilePosition, layer)
		var data := layer.get_cell_tile_data(tilePosition)
		
		var tile_base = data.get_custom_data("tile")
		if not tile_base: tile_base = baseTile
		
		var tile = tile_base.instantiate()
		add_tile(tile, Vector2(tilePosition) + (offset / tileSize).round())
		tile.set_texture(texture)
		if level : 
			tile.set_level(level)
			level.objects.append(tile)
		
		tile.walkable = data.get_custom_data("walkable")
		tile.castable = data.get_custom_data("castable")
		tile.breakable = data.get_custom_data("breakable")

func load_items_layer(layer: TileMapLayer, offset: Vector2, level: Level = null):
	for item in layer.get_children():
		if not item: continue
		item.reparent(items)
		item.init()
		if level: level.objects.append(item)
		
	for tilePosition in layer.get_used_cells():
		var data := layer.get_cell_tile_data(tilePosition)
		var item = data.get_custom_data("item")
		if not item: continue
		item = item.instantiate()
		add_item(item, Vector2(tilePosition) + (offset / tileSize).round())
		if level: level.objects.append(item)
		
func load_level(level: Level):
	add_child(level)
	if not level.is_node_ready(): await level.ready
	print("READY", level)
	load_tiles_layer(level.tile_map_layer, level.position, level)
	load_items_layer(level.item_layer, level.position, level)
	audio_manager.preload_level_audio(level.level_config.theme)

func add_lilipad_tile(tilePosition: Vector2) -> Tile:
	var newTile : Tile = lilipadBaseTile.instantiate()
	add_tile(newTile, tilePosition)
	return newTile

func add_ground_tile(tilePosition: Vector2) -> Tile:
	var newTile : Tile = baseTile.instantiate()
	add_tile(newTile, tilePosition)
	return newTile
	
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
	if tiles.has(key) and tiles[key] != null and tiles[key].is_active():
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
	if tile: 
		tiles[Vector2(x,y)] = tile
	else: tiles.erase(Vector2(x,y))

func set_tile_at_position(pos: Vector2, tile):
	set_tile(pos.x, pos.y, tile)
	
var textures = {}
func get_cell_texture(coord:Vector2i, layer: TileMapLayer) -> Texture:
	var source_id := layer.get_cell_source_id(coord)
	
	var source:TileSetAtlasSource = layer.tile_set.get_source(source_id) as TileSetAtlasSource
	var atlas_coord := layer.get_cell_atlas_coords(coord)
	
	var identifier = str(source_id,atlas_coord.x,atlas_coord.y)
	if textures.has(identifier): return textures[identifier]
	
	var rect := source.get_tile_texture_region(atlas_coord)
	var image:Image = source.texture.get_image()
	var tile_image := image.get_region(rect)
	textures[identifier] = ImageTexture.create_from_image(tile_image)
	return textures[identifier]
	
func handle_player_movement(pos: Vector2):
	var tile = get_tile_at_position(pos/tileSize)
	if tile and tile.level:
		if current_level != tile.level:
			set_level(tile.level)

func set_level(level: Level):
	if not current_level or current_level.level_config != level.level_config:
		audio_manager.play_theme(level.level_config.theme)
	current_level = level
	environment.set_level(level)
	print("Entering ", level)

func reset_level():
	if not current_level: return
	var level = current_level
	current_level = level.clone()
	level.clear()
	remove_child(level)
	level.queue_free()
	load_level(current_level)
	if current_level.spawn: 
		player.set_current_position(current_level.position + current_level.spawn.position)
	else:
		player.set_current_position(current_level.position)
