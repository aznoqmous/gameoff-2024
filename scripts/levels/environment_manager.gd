class_name EnvironmentManager
extends Node2D

var level : Level
var environments = {}
var active_environment: BaseEnvironment
var last_environment: BaseEnvironment
var motion_offset := Vector2.ZERO

@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var cloud_sprite: Sprite2D = $ParallaxBackground/ParallaxLayer/CloudSprite
@onready var background_sprite: Sprite2D = $ParallaxBackground/BackgroundLayer/BackgroundSprite
@onready var player: Player = $"../Player"

func _ready():
	cloud_sprite.modulate = Color.TRANSPARENT
	background_sprite.modulate = Color.TRANSPARENT

func _process(delta: float) -> void:
	motion_offset += Vector2(20, -10) * delta
	#if level and level.level_config and level.level_config.color:
		#cloud_sprite.modulate = lerp(cloud_sprite.modulate, level.level_config.cloud_color, delta / 2)
		#background_sprite.modulate = lerp(background_sprite.modulate, level.level_config.color, delta / 2)
	if active_environment: 
		active_environment.lerp_alpha(1.0, delta / 2)
		active_environment.parallax_layer.motion_offset = motion_offset
	if last_environment: 
		last_environment.parallax_layer.motion_offset = motion_offset
		if last_environment.modulate.a < 0.01: 
				player.remove_child(last_environment)
				last_environment = null
		else : last_environment.lerp_alpha(0.0, delta / 2)
		
func set_level(the_level: Level):
	if active_environment:
		last_environment = active_environment
	level = the_level
	active_environment = load_environment(level.level_config)
	if not active_environment: return
	
	if active_environment.get_parent():
		active_environment.reparent(player)
	else:
		player.add_child(active_environment)

func load_environment(level_config: LevelConfig):
	if not level_config or not level_config.environment: return
	if environments.has(level_config): return environments[level_config]
	var environment : BaseEnvironment = level_config.environment.instantiate()
	environments[level_config] = environment
	return environment
