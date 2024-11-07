class_name TileItem
extends Node2D

@export var pushable : bool = false
@export var destroyable : bool = false
@export var fallable: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game: Game = $"../../.."
var currentPosition = null
var currentTile : Tile = null 

func _ready() -> void:
	currentPosition = position
func _process(delta: float) -> void:
	if currentPosition and position != currentPosition:
		position = lerp(position, currentPosition, delta * 10)
		if position.distance_to(currentPosition) < 10:
			position = currentPosition
			if not game.get_tile_at_position(position/game.tileSize):
				fall()


func init():
	set_target_position(position)

func set_target_position(pos: Vector2):
	if currentTile: currentTile.set_item(null)
	currentPosition = (pos / game.tileSize).round() * game.tileSize
	var tile : Tile = game.get_tile_at_position(currentPosition / game.tileSize)
	currentTile = null
	if tile:
		currentTile = tile
		tile.set_item(self)

func fall():
	animation_player.play("Fall")
func remove():
	if currentTile: currentTile.set_item(null)
	queue_free()
