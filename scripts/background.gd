class_name Background
extends Node2D

var level : Level
var environments = {}
var active_environment: Node2D
var last_environment: Node2D

@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var cloud_sprite: Sprite2D = $ParallaxBackground/ParallaxLayer/CloudSprite
@onready var background_sprite: Sprite2D = $ParallaxBackground/BackgroundLayer/BackgroundSprite
@onready var player: Player = $"../Player"

func _ready():
	cloud_sprite.modulate = Color.TRANSPARENT
	background_sprite.modulate = Color.TRANSPARENT

func _process(delta: float) -> void:
	parallax_layer.motion_offset += Vector2(20, -10) * delta
	if level and level.level_config and level.level_config.color:
		cloud_sprite.modulate = lerp(cloud_sprite.modulate, level.level_config.cloud_color, delta / 2)
		background_sprite.modulate = lerp(background_sprite.modulate, level.level_config.color, delta / 2)
	if active_environment: 
		active_environment.modulate.a = lerp(active_environment.modulate.a, 1.0, delta / 2)
	if last_environment: 
		if last_environment.modulate.a < 0.01: last_environment.visible = false
		else : last_environment.modulate.a = lerp(last_environment.modulate.a, 0.0, delta / 2)
		
func set_level(the_level: Level):
	if active_environment:
		last_environment = active_environment
	level = the_level
	
	active_environment = load_environment(level.level_config)
	if not active_environment: return
	active_environment.visible = true

func load_environment(level_config: LevelConfig):
	if not level_config.environment: return
	if environments.has(level_config): return environments[level_config]
	var environment = level_config.environment.instantiate()
	environments[level_config] = environment
	player.add_child(environment)
	environment.modulate.a = 0
	return environment
