class_name Player
extends Node2D

@onready var game: Game = $".."
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var cast_line: Line2D = $Line2D
@onready var particles: CPUParticles2D = $Particles
@onready var body_scale_node: Node2D = $BodyScaleNode

var lastFlooredPosition: Vector2 = Vector2.ZERO
var baseParticles = preload("res://scenes/particles.tscn")
var baseSymbol = preload("res://scenes/spell_symbol.tscn")
@export var sightRadius = 5

func _ready() -> void:
	position = (position / game.tileSize).round() * game.tileSize
	currentPosition = position
	animationPlayer.play("Idle")
	init_spells()

var leave_tile_position = null
var inputDirection = Vector2(0,0)
func _process(delta: float) -> void:
	if isFalling: return;
	if not targetPositions.is_empty():
		var targetPosition = targetPositions[0]
		position = lerp(position, targetPosition, delta * 20)
		targetDirection = sign(currentPosition.x - targetPosition.x)
		if position.distance_to(targetPosition) < 10:
			position = targetPosition
			currentPosition = targetPosition
			if leave_tile_position: handle_leave_tile(leave_tile_position)
			leave_tile_position = targetPositions[0]
			targetPositions.pop_front()
			handle_movement(currentPosition)
				
	# look in right direction
	if targetDirection:
		body_scale_node.scale.x = lerp(body_scale_node.scale.x, targetDirection, delta * 20)
	else:
		body_scale_node.scale.x = lerp(body_scale_node.scale.x, sign(body_scale_node.scale.x), delta * 20)

signal on_leave_tile(pos: Vector2);
func handle_leave_tile(pos:Vector2):
	emit_signal("on_leave_tile", pos)
	var tile = game.get_tile_at_position(pos/game.tileSize)
	if tile: tile.handle_leave_tile()
	
func handle_movement(currentPosition):
	emit_signal("on_movement", currentPosition)
	
	if not targetPositions.is_empty():
		animationPlayer.stop()
		animationPlayer.play("Move")
	else: if isCasting:
		animationPlayer.play("Cast")
	else:
		animationPlayer.play("Idle")
		
	var playerPosition = currentPosition / game.tileSize
	var tile = game.get_tile_at_position(playerPosition)
	if tile:
		tile.bump()
		tile.handle_enter_tile()
		if not tile.breakable : lastFlooredPosition = currentPosition
		if not tile.is_castable():
			clear_cast()
	else:
		start_fall()
	
	
	
var isCasting = false
func _input(event: InputEvent):
	if isFalling: return;
	handle_movement_events(event)
	if Input.is_action_just_pressed("SwitchMode"):
		var tile = game.get_tile_at_position(get_last_position()/game.tileSize)
		if tile and !tile.is_castable(): return
		if !isCasting:
			isCasting = true
		else:
			isCasting = false
		particles.visible = isCasting
		if !isCasting:
			animationPlayer.play("Idle")
			cast()
		else:
			particles.restart()
			add_cast_position(get_last_position(), Vector2(0,0))
			animationPlayer.play("Cast")
	if Input.is_action_just_pressed("Reset"):
		game.reset_level()

var lastInputTime = 0
var joystick_pressed = false
var last_joystick_sensitivity = 0
func handle_movement_events(event: InputEvent):
	if "axis_value" in event:
		var joystick_sensitivity = abs(event.axis_value)
		if joystick_sensitivity < 0.5: return;
		if joystick_sensitivity < last_joystick_sensitivity: 
			last_joystick_sensitivity = joystick_sensitivity
			return
		last_joystick_sensitivity = joystick_sensitivity
	
	var movement_direction = Input.get_vector("MoveLeft","MoveRight","MoveDown","MoveUp")
	var direction = Vector2.ZERO
	if event.is_action_pressed("MoveRight"):
		direction.x = 1
	if event.is_action_pressed("MoveLeft"):
		direction.x = -1
	if event.is_action_pressed("MoveUp"):
		direction.y = -1
	if event.is_action_pressed("MoveDown"):
		direction.y =  1
			
	if direction != Vector2.ZERO:
		if inputDirection == direction and Time.get_ticks_msec() - lastInputTime < 100:
			return;
		move(direction * game.tileSize)
		lastInputTime = Time.get_ticks_msec()
		inputDirection = direction
	


signal on_movement(position: Vector2)

var targetDirection = null
var currentPosition = Vector2(0,0)
var targetPositions : Array
var lastPosition = null
var lastDirection = Vector2.ZERO
var lastMoveTime = 0

func move(direction: Vector2):
	if not is_floored(): return
	targetDirection = -sign(direction.x)
	
	var pos = currentPosition
	var lastPosition = get_last_position()
	if not targetPositions.is_empty() and Time.get_ticks_msec() - lastMoveTime < 200:
		var tile = game.get_tile_at_position((lastPosition + direction)/game.tileSize)
		if tile and not tile.is_walkable() : return;
		targetPositions.pop_back()
		if isCasting:
			castTrail.pop_back()
			cast_line.remove_point(cast_line.get_point_count()-1)
		direction += lastDirection
		pass
	else: if isCasting:
		play_particles()
		
	if not targetPositions.is_empty():
		pos = targetPositions[-1]
	else: if not isFalling:
		animationPlayer.play("Move")
	
	var tile = game.get_tile_at_position((pos + direction)/game.tileSize)
	if tile and not tile.is_walkable() and not tile.push(direction): return
	
	targetPositions.append(pos + direction)
	if isCasting:
		add_cast_position(pos + direction, direction)
	
	lastMoveTime = Time.get_ticks_msec()
	lastDirection = direction
	
var isFalling = false
func start_fall():
	clear_cast()
	isFalling = true
	animationPlayer.play("Fall")
	
func end_fall():
	isFalling = false
	targetPositions.clear()
	targetPositions.append(lastFlooredPosition)

var castTrail = []
func add_cast_position(pos, dir):
	if not cast_line.points.is_empty() and cast_line.points[-1] == pos : return;
	cast_line.add_point(pos)
	var lastPos = Vector2.ZERO
	if not castTrail.is_empty():
		lastPos = castTrail[-1]
	castTrail.append(lastPos + dir / game.tileSize)
	
func cast():
	var min = Vector2.ZERO
	var max = Vector2.ZERO
	for pos in castTrail:
		if min.x > pos.x: min.x = pos.x
		if max.x < pos.x: max.x = pos.x
		if min.y > pos.y: min.y = pos.y
		if max.y < pos.y: max.y = pos.y
	
	var spellCanvas = []
	var spellMask = []
	
	for y in range(0, max.y - min.y + 1):
		spellCanvas.append([])
		spellMask.append([])
		for x in range(0, max.x - min.x + 1):
			spellCanvas[y].append(0)
			spellMask[y].append(0)
			
	var index = 1
	for pos in castTrail:
		spellCanvas[pos.y - min.y][pos.x - min.x] = index
		spellMask[pos.y - min.y][pos.x - min.x] = 1
		index += 1
		
	print(spellCanvas)

	for spell in spells:
		for trail in spell.trails:
			if trail == spellCanvas or trail == spellMask:
				print("Casting " + spell.name)
				if spell.has("spell"):
					spell.spell.cast(trail)
					
					var newSpellSymbol : SpellSymbol = baseSymbol.instantiate()
					add_child(newSpellSymbol)
					var newLine : Line2D = cast_line.duplicate()
					newLine.top_level = false
					newSpellSymbol.add_line(newLine)
					newSpellSymbol.set_text(spell.name)
					newSpellSymbol.label.position = position
	clear_cast()
	
func is_floored():
	var pos = get_last_position()
	pos /= game.tileSize
	return game.get_tile(pos.x, pos.y)
	
func set_current_position(pos: Vector2):
	position = pos
	currentPosition = position
	handle_movement(position)
	
func get_last_position():
	if not targetPositions.is_empty():
		return targetPositions[-1]
	return currentPosition
	
func clear_cast():
	castTrail = []
	cast_line.clear_points()
	isCasting = false
	particles.visible = false
	animationPlayer.play("Idle")

func play_particles():
	var newParticles : CPUParticles2D = baseParticles.instantiate()
	newParticles.position = currentPosition
	newParticles.restart()
	add_child(newParticles)
	newParticles.finished.connect(func(): newParticles.queue_free())

# Spells
func init_spells():
	for spell in spells:
		if spell.has("rotate") and spell.rotate:
			var newTrails = []
			for trail in spell.trails:
				var once = rotate_array(trail)
				var twice = rotate_array(once)
				var thrice = rotate_array(twice)
				newTrails.append_array([once,twice,thrice])
			spell.trails.append_array(newTrails)
			
@onready var jump: Jump = $Spells/Jump
@onready var spawn_plant: SpawnPlant = $Spells/SpawnPlant
@onready var spawn_stone: SpawnStone = $Spells/SpawnStone
@onready var spawn_energy_ball: SpawnEnergyBall = $Spells/SpawnEnergyBall
@onready var spawn_tornado: SpawnTornado = $Spells/SpawnTornado
@onready var spells = [
	{
		"name": "Jump",
		"trails": [
			[[2,1],[3,0],[4,0]],
			[[1,2],[0,3],[0,4]],
		],
		"rotate": true,
		"spell": jump
	},
	{
		"name": "Plant",
		"trails": [
			[[4, 3, 2], [5, 9, 10], [6, 7, 8]],
			[[6, 7, 8], [5, 9, 10], [4, 3, 2]],
			[[3, 1, 9], [4, 10, 8], [5, 6, 7]],
			[[9, 1, 3], [8, 10, 4], [7, 6, 5]]
		],
		"rotate": true,
		"spell": spawn_plant
	},
	{
		"name": "Stone",
		"trails": [
			[[5, 4, 3], [6, 1, 2], [7, 8, 9]],
			[[7, 8, 9], [6, 1, 2], [5, 4, 3]]
		],
		"rotate": true,
		"spell": spawn_stone
	},
	{
		"name": "EnergyBall",
		"trails": [
			[[0, 3, 0], [2, 1, 4], [0, 5, 0], [0, 6, 0]],
			[[0, 3, 0], [4, 1, 2], [0, 5, 0], [0, 6, 0]]
		],
		"rotate": true,
		"spell": spawn_energy_ball
	},
	{
		"name": "Tornado",
		"trails": [
			[[4, 3, 2], [5, 1, 0], [0, 6, 0]]
		],
		"rotate": false,
		"spell": spawn_tornado
	}
]
func rotate_array(arr) -> Array:
	var new_arr = []
	for i in range(len(arr[0])):
		var row = []
		for j in range(len(arr)):
			row.append(arr[len(arr) - j - 1][i])
		new_arr.append(row)
	return new_arr
