class_name TileItem
extends Node2D

@export var pushable : bool = false
@export var destroyable : bool = false
@export var fallable: bool = true
@export var walkable: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game: Game = $"../../.."
@onready var fall_audio: AudioStreamPlayer2D = $FallAudio

var currentPosition = null
var currentTile : Tile = null
var lastPosition = null

signal on_movement(position: Vector2)

func _ready() -> void:
	currentPosition = position
	scale = Vector2.ZERO

func _process(delta: float) -> void:
	if currentPosition and position != currentPosition:
		position = lerp(position, currentPosition, delta * 10)
		if position.distance_to(currentPosition) < 10:
			position = currentPosition
			emit_signal("on_movement", position)
			if fallable and not game.get_tile_at_position(position/game.tileSize):
				fall()

func init():
	set_target_position(position)

func set_target_position(pos: Vector2):
	if currentTile: currentTile.set_item(null)
	currentPosition = (pos / game.tileSize).round() * game.tileSize
	lastPosition = currentPosition
	var tile : Tile = game.get_tile_at_position(currentPosition / game.tileSize)
	currentTile = null
	if tile:
		currentTile = tile
		tile.set_item(self)

func fall():
	animation_player.play("Fall")
	if fall_audio: fall_audio.play()
func remove():
	if currentTile and currentTile._item == self: currentTile.set_item(null)
	queue_free()
	
func push(direction: Vector2):
	set_target_position(currentPosition + direction)

func get_tile() -> Tile:
	return game.get_tile_at_position(currentPosition/game.tileSize)
