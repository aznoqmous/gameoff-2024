extends Node
@onready var screen_overlay: ScreenOverlay = $ScreenOverlay

@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var coin_count_label: Label = $CanvasLayer2/CenterContainer/HBoxContainer/Control/CoinCountLabel
@onready var time_label: Label = $CanvasLayer2/CenterContainer/HBoxContainer/TimeLabel
@onready var reset_count_label: Label = $CanvasLayer2/CenterContainer/HBoxContainer/TimeLabel2

func _ready():
	run_time = SceneManager.run_time
	coin_count = SceneManager.coin_count
	max_coins = SceneManager.max_coins
	time_label.text = "0m0s"
	coin_count_label.text = str("0/", max_coins)
	reset_count_label.text = "0"
	
var run_time = 0.0
var time = 0.0
var coin_count = 0.0
var coins = 0.0
var max_coins = 0.0
var resets = 0.0
var is_show_results = false

func show_results():
	is_show_results = true

func _process(delta: float) -> void:
	parallax_layer.motion_offset.x += delta * 10
	parallax_layer.motion_offset.y -= delta * 5

	if is_show_results:	
		time = lerp(time, float(run_time), delta)
		time_label.text = get_human_time()
		coins = lerp(coins, float(coin_count), delta)
		coin_count_label.text = str(round(coins), "/", max_coins)
		resets = lerp(resets, float(SceneManager.reset_count), delta)
		reset_count_label.text = str(round(resets))
func get_human_time():
	var seconds = int(time) % 60
	var minute = int(time/60.0)
	return str(minute, "m", seconds,"s")
