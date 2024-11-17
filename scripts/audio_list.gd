class_name AudioList2D
extends AudioStreamPlayer2D

@export var streams : Array[AudioStream]

var index = 0

func _ready():
	stream = get_current_stream()

func play_from_list():
	stream = get_current_stream()
	play()
	next()

func next():
	index = (index + 1) % streams.size()
	pass

func reset():
	index = 0
	
func get_current_stream():
	return streams[index]
	
