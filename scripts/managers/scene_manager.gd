extends Node

var current_scene = null
var game_scene = "res://scenes/game.tscn"
var title_scene = "res://scenes/title.tscn"
var pre_scene_manager_progress = preload("res://scenes/scene_manager_progress.tscn")
var scene_manager_progress: SceneManagerProgress

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	#load_title()
	
	scene_manager_progress = pre_scene_manager_progress.instantiate()
	add_child(scene_manager_progress)
	scene_manager_progress.visible = false

func load_title():
	load_scene(title_scene)
	
func load_game():
	load_scene_progress(game_scene)

func load_scene(path):
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path):
	var s = ResourceLoader.load(path)
	set_scene(s.instantiate())
	
func set_scene(scene):
	current_scene.free()
	current_scene = scene
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func load_scene_progress(path):
	scene_manager_progress.visible = true
	scene_manager_progress.set_progress(0.0)
	await scene_manager_progress.appear()
	var s = await _thread_load(path)
	set_scene(s.instantiate())
	await scene_manager_progress.disappear()
	scene_manager_progress.visible = false
	
func _thread_load(path):
	ResourceLoader.load_threaded_request(path)
	var tree = get_tree()
	var progress = 0
	var arrProgress = [0]
	while progress < 1:
		await tree.process_frame
		ResourceLoader.load_threaded_get_status(path, arrProgress)
		progress = arrProgress[0]
		scene_manager_progress.set_progress(progress)
	return ResourceLoader.load_threaded_get(path)
	
