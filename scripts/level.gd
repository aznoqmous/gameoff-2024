class_name Level
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var item_layer: TileMapLayer = $ItemLayer
@onready var game: Game = $".."
@onready var spawn: Node2D = $Spawn

@export var level_config: LevelConfig

var objects = []

func _ready() -> void:
	game.levels.append(self)
	tile_map_layer.visible = false
	item_layer.visible = false
	pass


func _process(delta: float) -> void:
	pass

func clear():
	for obj in objects:
		if obj != null: obj.queue_free()
	objects = []
