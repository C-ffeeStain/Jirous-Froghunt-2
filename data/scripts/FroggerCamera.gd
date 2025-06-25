extends Camera2D

var paused = true
var camera_distance = 0

const NORMAL_SPEED = 15

@onready var score_label: Label = get_parent().get_node("CanvasLayer/ScoreLabel")

const SPEEDUP_THRESHOLD = 250

@onready var player: Sprite2D = get_parent().get_node("Player")

func end_game():
	if Globals.high_scores["Frogger"] < int(score_label.text):
		Globals.high_scores["Frogger"] = int(score_label.text)
	Globals.minigame = "Frogger"
	Globals.transition("MinigameHighScores")

func _process(delta: float) -> void:
	var camera_coords = Vector2(position.x - 400 , position.y - 225)
	if player.position.x < camera_coords.x:
		end_game()
	camera_distance = abs(player.position.x - camera_coords.x)
	if !paused:
		if camera_distance < SPEEDUP_THRESHOLD:
			position.x += NORMAL_SPEED * delta
		elif camera_distance > SPEEDUP_THRESHOLD and camera_distance < 800:
			position.x += NORMAL_SPEED * ((camera_distance * 2) / SPEEDUP_THRESHOLD) * delta
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		paused = false

	score_label.text = str(floor(position.x - 400))
