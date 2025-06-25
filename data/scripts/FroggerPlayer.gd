extends Sprite2D

var movement_delay = 0

var attached = true

var check_next_frame = false

var river_checks = 0

var move_dir = -1

var new_pos

const CELL_SIZE = 50

@onready var tween: Tween = create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if movement_delay > 0: return
	if event.is_action_pressed("ui_right"):
		frame = 0
		flip_h = true
		
		new_pos = Vector2(position.x + CELL_SIZE, position.y)
		create_tween().tween_property(self, "position", new_pos, 0.1667)
	elif event.is_action_pressed("ui_left"):
		frame = 0
		flip_h = false
		
		create_tween().tween_property(self, "position", Vector2(position.x - CELL_SIZE, position.y), 0.1667) 
	elif event.is_action_pressed("ui_up"):
		frame = 3
		flip_h = false
		
		new_pos = Vector2(position.x, position.y - CELL_SIZE)
		create_tween().tween_property(self, "position", new_pos, 0.1667) 
	elif event.is_action_pressed("ui_down"):
		frame = 2
		flip_h = false
		
		new_pos = Vector2(position.x, position.y + CELL_SIZE)
		create_tween().tween_property(self, "position", new_pos, 0.1667) 
		

func in_river(): # 0 forward, 1 back, 2 up, 3 down
	for log_column in get_parent().get_node("LogSpawners").get_children():
		if log_column.column == int((position.x - 25) / 50): 
			for log_node in log_column.get_children():
				if log_node.has_player:
					attached = false
					return false
			if tween.is_running():
				return false
			return true
		else:
			attached = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	if in_river():
		if river_checks > 0:
			get_parent().get_node("Camera2D").end_game()
		river_checks += 1
	else:
		river_checks = 0
	if movement_delay > 0: movement_delay -= 1
	
	#if new_pos != position:
		#create_tween().tween_property(self, "position", new_pos, 0.1667)
	
	if attached:
		position.x = int(position.x / CELL_SIZE) * CELL_SIZE + 25
		position.y = int(position.y / CELL_SIZE) * CELL_SIZE + 25
	
	if position.y > 450 or position.y < 0:
		get_parent().get_node("Camera2D").end_game()
