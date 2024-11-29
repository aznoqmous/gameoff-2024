class_name Level
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var item_layer: TileMapLayer = $ItemLayer
@onready var game: Game = $"/root/Game"
@onready var spawn: Node2D = $Spawn
@onready var tips: Node2D = $Sign

@export var level_config: LevelConfig
@export var audio_track: AudioStream
@export var stop_current_audio_track: bool

var resets = 0
var show_tips_reset_count = 2

var refLevel: Level # level kept as reference inside game

var objects = []

var scene;

func _ready() -> void:
	game.levels.append(self)
	tile_map_layer.visible = false
	item_layer.visible = false
	if tips: tips.visible = false
	
# called only on reference levels, not on clones
func init():
	scene = load(self.scene_file_path)
	refLevel = self
	
func clear():
	for obj in objects:
		if obj != null: obj.queue_free()
	objects = []

func handle_reset():
	resets += 1
	if resets >= show_tips_reset_count and tips: tips.visible = true

func clone():
	var level : Level = scene.instantiate()
	level.refLevel = refLevel
	level.scene = scene
	level.global_position = refLevel.global_position
	return level
