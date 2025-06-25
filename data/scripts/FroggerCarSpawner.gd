extends Node2D

const CAR_SCRIPT = preload("res://data/scripts/FroggerCar.gd")

var direction_mod = 1

const SINGLE_TILE_FRAME = 3
const MID_SECTION_FRAME = 1
const START_FRAME = 0
const END_FRAME = 2

const MIN_SPEED = 125
const MAX_SPEED = 275

var create_next_car = true

const ROAD_STRIP = preload("res://data/minigames/frogger/road.png")
const CAR_TEXTURE = preload("res://data/minigames/frogger/cars.png")

var spawn_timer = 0

@export var column: int = 0
var car_speed: int = 100
@export var spawn_from_bottom: bool = false

var car_num: int = 0

func car_in_the_way():
	for child in get_children():
		if child.position.y < 150 or child.position.y > 350:
			print("waiting")
			return true
	return false

func make_strip(strip_variant: int = 1):
	var STRIP_CONTAINER = get_node("../../Strips")
	var strip = Sprite2D.new()
	strip.texture = ROAD_STRIP
	strip.hframes = 3
	strip.frame = strip_variant
	
	strip.position.x = position.x
	strip.position.y = 225

	STRIP_CONTAINER.add_child(strip)

func create_car(size: int, offset: int = 0) -> Node2D:
	var sprite
	var container = Node2D.new()
	container.name = "Car" + str(car_num)
	car_num += 1
	if size == 1:
		sprite = Sprite2D.new()
		sprite.texture = CAR_TEXTURE
		sprite.hframes = 2
		sprite.vframes = 6
		sprite.frame = randi() % 6
		container.add_child(sprite)
	elif size == 3:
		for section in range(size):
			sprite = Sprite2D.new()
			sprite.texture = CAR_TEXTURE
			sprite.hframes = 2
			sprite.vframes = 6
			sprite.frame = 6 + section * 2
			sprite.position.y = section * 50
			
			container.add_child(sprite)
	if spawn_from_bottom:
		container.position.y = 525 + randi_range(10, 100) + offset
	else:
		container.position.y = -50 * size - 25 - randi_range(10, 100) - offset
	container.set_script(CAR_SCRIPT)
	add_child(container)
	return container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car_speed = randi_range(MIN_SPEED, MAX_SPEED)
	if spawn_from_bottom:
		direction_mod = -1
	
	create_car(1)
	var offset = (randi() % 5 + 2) * 50
	create_car(1, offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass
	#if spawn_timer <= 0 and get_child_count() < 2:
		#create_next_car = true
		#spawn_timer = 120
	#else:
		#spawn_timer -= 1
	#
	#if create_next_car:
		#create_next_car = false
		#if !car_in_the_way():
			#create_car(1)
