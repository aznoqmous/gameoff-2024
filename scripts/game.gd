extends Node2D

var tile = load("res://scenes/tile.tscn")
var mapSize = Vector2(10,10)
var tiles = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_map()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_map() -> void:
	for x in mapSize.x:
		for y in mapSize.y:
			print(x, " ", y)
			var newTile = tile.instantiate()
			newTile.position.x = x * 100
			newTile.position.y = y * 100
			add_child(newTile)
