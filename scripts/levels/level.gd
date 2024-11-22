class_name Level
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var item_layer: TileMapLayer = $ItemLayer
@onready var game: Game = $".."
@onready var spawn: Node2D = $Spawn

@export var level_config: LevelConfig

var refLevel: Level # level kept as reference inside game

var objects = []

var scene;

func _ready() -> void:
	game.levels.append(self)
	tile_map_layer.visible = false
	item_layer.visible = false
	
# called only on reference levels, not on clones
func init():
	scene = load(self.scene_file_path)
	refLevel = self
	
func clear():
	for obj in objects:
		if obj != null: obj.queue_free()
	objects = []

func clone():
	var level : Level = scene.instantiate()
	level.refLevel = refLevel
	level.scene = scene
	level.global_position = refLevel.global_position
	return level
