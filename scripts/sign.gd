extends Area2D

@export var message: String;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(handle_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func handle_area_entered(area: Area2D):
	print(message, area)
