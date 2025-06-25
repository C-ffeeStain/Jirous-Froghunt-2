extends Node2D

var paused = true

const SNAKE = 0
const APPLE = 1

var score = 0

const COLUMNS = 32 # 800 / 50 = 16
const ROWS = 18 # 450 / 50 = 9

var input_queue = []

var last_direction = Vector2i.RIGHT
var direction = Vector2i(1, 0)

var snake_body = [Vector2i(6, 4), Vector2i(5, 4), Vector2i(4, 4)] 
var apple_pos: Vector2i

var grow_this_tick = false
var inputted_this_tick = false

func place_apple():
	randomize()
	var x = randi_range(0, COLUMNS - 1)
	var y = randi_range(0, ROWS - 1)
	
	return Vector2i(x, y)

func delete_tiles(source_layer: int):
	var tiles = $SnakeAppleLayer.get_used_cells_by_id(source_layer)
	for tile in tiles:
		$SnakeAppleLayer.erase_cell(Vector2i(tile[0], tile[1]))

func draw_apple():
	$SnakeAppleLayer.set_cell(apple_pos, APPLE, Vector2i(0, 0))

func move_snake():	
	delete_tiles(SNAKE)
	var body_copy
	if grow_this_tick:
		body_copy = snake_body.slice(0, snake_body.size())
		grow_this_tick = false
	else:
		body_copy = snake_body.slice(0, snake_body.size() - 1)
	
	var new_head = body_copy[0] + direction
	
	body_copy.insert(0, new_head)
	
	snake_body = body_copy

func check_game_over():
	var head = snake_body[0]
	
	# out of bounds
	if head.x < 0 or head.x > COLUMNS - 1 or head.y < 0 or head.y > ROWS - 1:
		return true
	
	# snake bites itself
	
	for segment in snake_body.slice(1, snake_body.size()):
		if head == segment:
			return true
	return false

func draw_snake():
	#for segment in snake_body:
		#$SnakeAppleLayer.set_cell(segment, SNAKE, Vector2i(7, 0))
	
	for segment_index in snake_body.size():
		var segment = snake_body[segment_index]
		
		if segment_index == 0:
			var head_dir = segment_relation(segment, snake_body[segment_index + 1])
			
			if head_dir == "right":
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(2, 0))
			elif head_dir == "top":
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(3, 0))
			elif head_dir == "bottom":
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(3, 0), TileSetAtlasSource.TRANSFORM_FLIP_V)
			elif head_dir == "left":
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(2, 0), TileSetAtlasSource.TRANSFORM_FLIP_H)
		elif segment_index == snake_body.size() - 1:
			var tail_dir = segment_relation(segment, snake_body[segment_index - 1])
			
			if tail_dir == "right":
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(1, 0))
			elif tail_dir == "top":
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(0, 0))
			elif tail_dir == "bottom":
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(0, 0), TileSetAtlasSource.TRANSFORM_FLIP_V)
			elif tail_dir == "left":
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(1, 0), TileSetAtlasSource.TRANSFORM_FLIP_H)
		else:
			var prev_dir = snake_body[segment_index - 1] - segment
			var next_dir = snake_body[segment_index + 1] - segment
			
			if prev_dir.x == next_dir.x:
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(1, 1))
			elif prev_dir.y == next_dir.y:
				$SnakeAppleLayer.set_cell(segment, 0, Vector2i(0, 1))
			else:
				if prev_dir.x == -1 and next_dir.y == -1 or next_dir.x == -1 and prev_dir.y == -1:
					$SnakeAppleLayer.set_cell(segment, 0, Vector2i(2, 1), TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V)
				elif prev_dir.x == -1 and next_dir.y == 1 or next_dir.x == -1 and prev_dir.y == 1:
					$SnakeAppleLayer.set_cell(segment, 0, Vector2i(2, 1), TileSetAtlasSource.TRANSFORM_FLIP_H)
				elif prev_dir.x == 1 and next_dir.y == -1 or next_dir.x == 1 and prev_dir.y == -1:
					$SnakeAppleLayer.set_cell(segment, 0, Vector2i(2, 1), TileSetAtlasSource.TRANSFORM_FLIP_V)
				elif prev_dir.x == 1 and next_dir.y == 1 or next_dir.x == 1 and prev_dir.y == 1:
					$SnakeAppleLayer.set_cell(segment, 0, Vector2i(2, 1))

func segment_relation(first: Vector2i, second: Vector2i):
	var diff = second - first
	
	if diff == Vector2i(-1, 0): return "right"
	elif diff == Vector2i(1, 0): return "left"
	elif diff == Vector2i(0, 1): return "bottom"
	elif diff == Vector2i(0, -1): return "top"

func check_apple_eaten():
	#print(snake_body[0])
	#print(apple_pos)
	if snake_body[0] == apple_pos:
		grow_this_tick = true
		apple_pos = place_apple()
		score += 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and paused:
		$CanvasLayer.remove_child(get_node("CanvasLayer/Screen"))
		
		paused = false
	
	if event.is_action("ui_quit") and $CanvasLayer.has_node("Screen"):
		Globals.transition("Minigames")
	
	if inputted_this_tick: return
	
	if Input.is_action_just_pressed("ui_right"): 
		if not last_direction == Vector2i.LEFT:
			direction = Vector2i.RIGHT
			inputted_this_tick = true
	elif Input.is_action_just_pressed("ui_left"): 
		if not last_direction == Vector2i.RIGHT:
			direction = Vector2i.LEFT
			inputted_this_tick = true
	if Input.is_action_just_pressed("ui_up"): 
		if not last_direction == Vector2i.DOWN:
			direction = Vector2i.UP
			inputted_this_tick = true
	elif Input.is_action_just_pressed("ui_down"): 
		if not last_direction == Vector2i.UP:
			direction = Vector2i.DOWN
			inputted_this_tick = true

	last_direction = direction
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.minigame = "Snake"
	apple_pos = place_apple()
	
	draw_snake()
	draw_apple()


func _on_snake_tick_timeout() -> void:
	if paused: return
	
	inputted_this_tick = false
	
	move_snake()
	draw_apple()
	draw_snake()
	check_apple_eaten()
	
	
	$CanvasLayer/ScoreLabel.text = str(score)
	
	if check_game_over():
		if Globals.high_scores["Snake"] < score:
			Globals.high_scores["Snake"] = score
		Globals.transition("MinigameHighScores")
