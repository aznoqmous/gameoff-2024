class_name Tile
extends Node2D

@onready var player: Player = $"../../../Player"
@onready var game: Game = $"../../.."
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var activators : Array[ActivatorTileItem] = []
@export var breakable = false

var castable = true
var walkable = true
var size = 0
var memory = 0
var level: Level
var _item = null # stone, lever
var _destroy = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2.ZERO
	player.on_movement.connect(update_memory)
	update_memory(player.position)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_animation(delta)
	pass

func bump():
	scale = Vector2.ONE * 0.5

func update_memory(playerPosition: Vector2):
	if position.distance_to(player.position) < game.tileSize * player.sightRadius:
		memory += 1

func handle_animation(delta: float):
	if _destroy:
		scale = lerp(scale, Vector2.ZERO, delta * 10)
		if scale.length() < 0.1: queue_free()
		return
	#if not position.distance_to(player.position) < game.tileSize * player.sightRadius:
		#memory -= delta
	if memory > 0 and is_active():
		size = 1 + sin(Time.get_ticks_msec()/5000.0 * 2 * PI + position.x + position.y) / 20
	else:
		size = 0
	scale = lerp(scale, Vector2.ONE * size, delta * 10)
	
	if _item: _item.scale = lerp(_item.scale, scale, delta * 10)

func is_active() -> bool:
	if activators.is_empty(): return true
	for activator in activators: 
		if activator and not activator.active : return false
	return true

func is_walkable() -> bool:
	if not walkable: return false
	if not _item: return true
	return _item.walkable
	
func is_castable() -> bool:
	return castable
	
func set_item(item):
	_item = item

func push(direction: Vector2) -> bool:
	direction = (direction/game.tileSize).round() * game.tileSize
	var tileItem : TileItem = _item
	if tileItem and tileItem.pushable:
		var tile = game.get_tile_at_position((tileItem.currentPosition + direction)/game.tileSize)
		if not tile or (tile and tile.is_walkable()):
			tileItem.push(direction)
			return true
	return false

func set_texture(texture: ImageTexture):
	sprite_2d.texture = texture

func set_level(the_level: Level):
	level = the_level

func handle_leave_tile():
	if not breakable: return
	_destroy = true
	game.set_tile_at_position(position/game.tileSize, null)
	pass
