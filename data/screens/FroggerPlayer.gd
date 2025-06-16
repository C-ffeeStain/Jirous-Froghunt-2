extends Sprite2D

var movement_delay = 10
var column = 0
var row = 0

const CELL_SIZE = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func process_input() -> void:
	if movement_delay > 0: return
	if Input.is_action_pressed("ui_right"):
		column += 1
		movement_delay += 10
	elif Input.is_action_pressed("ui_left"):
		column -= 1
		movement_delay += 10
	elif Input.is_action_pressed("ui_up"):
		row -= 1
		movement_delay += 10
	elif Input.is_action_pressed("ui_down"):
		row += 1
		movement_delay += 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	process_input()
	position.x = column * CELL_SIZE + CELL_SIZE / 2
	position.y = row * CELL_SIZE + CELL_SIZE / 2
	if movement_delay > 0: movement_delay -= 1
