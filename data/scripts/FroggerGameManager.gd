extends Node2D

var total_columns = 1
var last = ""

@onready var player = get_parent().get_node("Player")

const CAR_CREATOR_SCRIPT = preload("res://data/scripts/FroggerCarSpawner.gd")
const LOG_CREATOR_SCRIPT = preload("res://data/scripts/FroggerLogSpawner.gd")

@onready var CAR_CREATOR_CONTAINER = get_parent().get_node("CarSpawners")
@onready var LOG_CREATOR_CONTAINER = get_parent().get_node("LogSpawners")

const RIVER_STRIP = preload("res://data/minigames/frogger/water.png")
const ROAD_STRIP = preload("res://data/minigames/frogger/road.png")

@onready var STRIP_CONTAINER = get_parent().get_node("Strips")
@onready var camera = get_parent().get_node("Camera2D")

func add_columns(num: int = 1, type: String = "ROAD"):
	if num == 1:
		return
	for col in range(num):
		var new_creator_node = Node2D.new()
		new_creator_node.position.x = total_columns * 50 + 25
		if type == "ROAD":
			new_creator_node.set_script(CAR_CREATOR_SCRIPT)
			CAR_CREATOR_CONTAINER.add_child(new_creator_node)
			#print(col)
			if col == 0:
				new_creator_node.make_strip(0)
			elif col == num - 1:
				new_creator_node.make_strip(2)
			else:
				new_creator_node.make_strip(1)
		else:
			new_creator_node.set_script(LOG_CREATOR_SCRIPT)
			LOG_CREATOR_CONTAINER.add_child(new_creator_node)
		
		new_creator_node.column = total_columns
		if total_columns % 2 == 0:
			new_creator_node.spawn_from_bottom = true
		
		total_columns += 1
		
	last = type
var last_added_pos = 0

func _ready() -> void:
	for _num in range(3):
		add_columns(randi_range(2, 5), "ROAD")
		add_columns(randi_range(2, 5), "LOG")

func _physics_process(_delta: float) -> void:
	if int(player.position.x - 25) % 100 == 0 and last_added_pos != player.position.x:
		last_added_pos = player.position.x
		if last == "ROAD":
			add_columns(randi_range(2, 5), "LOG")
		else:
			add_columns(randi_range(2, 5), "ROAD")
