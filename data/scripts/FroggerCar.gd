extends Node2D

var car_speed = 100
var direction = 1
var tiles = 1

var hit_player = false
var player

var truck_sprite = preload("res://data/minigames/frogger/truck.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	
	car_speed = parent.car_speed
	if parent.spawn_from_bottom:
		direction = -1
	else:
		get_child(0).flip_v = true

	player = get_node("../../../Player")
	
	for child in get_children():
		child.frame = randi() % 6

func get_bounds():
	# top left, bottom right
	var bounds
	if get_child(0).texture == truck_sprite:
		bounds = [
			[global_position.x - 25, global_position.y - 25],
			[global_position.x + 25, global_position.y - 25 + 50 * tiles]
		]
	else:
		bounds = [
			[global_position.x - 25, global_position.y - 25],
			[global_position.x + 25, global_position.y - 25 + 50 * tiles]
		]
	return bounds

func check_for_hit():
	var bounds = get_bounds()
	if player.position.x < bounds[1][0] and player.position.x > bounds[0][0]:
		if player.position.y < bounds[1][1] and player.position.y > bounds[0][1]:
			hit_player = true
			return
	hit_player = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_for_hit()
	position.y += car_speed * delta * direction
	if hit_player:
		get_node("../../../Camera2D").end_game()
	
	if direction == -1:
		if position.y < -50:
			get_child(0).frame = randi() % 6
			position.y = 575
	else:
		if position.y > 475:
			get_child(0).frame = randi() % 6
			position.y = -25
