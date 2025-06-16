extends Node2D

const LOG_TEXTURE = preload("res://data/minigames/frogger/log.png")
const LOG_SCRIPT = preload("res://data/scripts/FroggerLog.gd")

var direction_mod = 1

const SINGLE_TILE_FRAME = 3
const MID_SECTION_FRAME = 1
const START_FRAME = 0
const END_FRAME = 2

var spawn_timer = 0

@export var column: int = 0
@export var spawn_from_bottom: bool = false

var log_num: int = 0

func create_log(size: int) -> Node2D:
	var sprite
	var container = Node2D.new()
	container.name = "Log" + str(log_num)
	log_num += 1
	if size == 1:
		sprite = Sprite2D.new()
		sprite.texture = LOG_TEXTURE
		sprite.vframes = 4
		sprite.frame = SINGLE_TILE_FRAME
		sprite.set_script(LOG_SCRIPT)
		sprite.reverse_dir = spawn_from_bottom
		container.add_child(sprite)
		add_child(container)
		return container
	for section in range(size):
		sprite = Sprite2D.new()
		sprite.texture = LOG_TEXTURE
		sprite.vframes = 4
		if section == 0:
			sprite.frame = START_FRAME
		elif section > 0 and section < size - 1:
			sprite.frame = MID_SECTION_FRAME
		else:
			sprite.frame = END_FRAME
		#sprite.position.x = 0
		sprite.position.y = section * 50
		container.add_child(sprite)
	if spawn_from_bottom: container.position.y = 575
	else: container.position.y = -50 * size - 125
	add_child(container)
	return container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if spawn_from_bottom:
		direction_mod = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if spawn_timer <= 0:
		create_log(randi_range(1, 3))
		spawn_timer = 360
	else:
		spawn_timer -= 1
	for log_object in get_children():
		var segments = log_object.get_child_count()
		log_object.position.y += 100 * delta * direction_mod
		if spawn_from_bottom:
			if log_object.position.y < -(50 * segments - 25):
				remove_child(log_object)
		else:
			if log_object.position.y > 475:
				remove_child(log_object)
