extends Node2D

var log_speed = 100
var direction = 1
var segments = 1

var has_player = false
var player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	
	log_speed = parent.log_speed
	if parent.spawn_from_bottom:
		direction = -1

	player = get_node("../../../Player")
	
	segments = get_child_count()

func get_bounds():
	# top left, bottom right
	return [
		[global_position.x - 25, global_position.y - 25],
		[global_position.x + 25, global_position.y - 25 + 50 * segments]
	]

func player_on_me():
	var bounds = get_bounds()
	if player.position.x < bounds[1][0] and player.position.x > bounds[0][0]:
		if player.position.y < bounds[1][1] and player.position.y > bounds[0][1]:
			has_player = true
			return
	has_player = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_on_me()
	position.y += log_speed * delta * direction
	if has_player:
		player.position.y += log_speed * delta * direction
	
	if direction == -1:
		if position.y < -325:
			position.y = 575
	else:
		if position.y > 475:
			position.y = -325
