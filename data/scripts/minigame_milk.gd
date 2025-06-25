extends Node2D

var GaugeBallEndPos = 602
var GaugeBallStartPos = 175

var BackgroundStartPos = 961
var BackgroundEndPos = -156


var PitcherStartPos = 142
var BatterStartPos = 1676

var BaseballStartPos = 106
var BaseballEndPos = 1085

var BaseballXSpeed = 375
var BaseballYSpeed = 0
var BackgroundSpeed = 675
var GaugeBallSpeed = 375

var bb_moved = 0

var fading_counter = 0

var frame_started = -1
var stopped = false

var fading_state = -1

var bg_stopped = false

var fade_mod = 0.01

var balls_scored = 0
var strikes = 0

var result

var PopupTextureStrike1 = preload("res://data/minigames/bkoi/label_strike_1.png")
var PopupTextureStrike2 = preload("res://data/minigames/bkoi/label_strike_2.png")
var PopupTextureStrike3 = preload("res://data/minigames/bkoi/label_strike_3.png")
var PopupTextureSafe = preload("res://data/minigames/bkoi/label_safe.png")
var PopupTextureOut = preload("res://data/minigames/bkoi/label_out.png")
var PopupTextureHomerun = preload("res://data/minigames/bkoi/label_homerun.png")

var ball_used = preload("res://data/minigames/bkoi/bball_ui.png")
var ball_unused = preload("res://data/minigames/bkoi/ball_ui.png")

var ball_state = -1
var hit_counter = 0

func change_sprites(new_pos: String):
	if new_pos == "strike":
		$Batter.frame = 4
	elif new_pos == "hit":
		$Batter.frame = 3
	elif new_pos == "ready":
		$Pitcher.frame = 6
		$Batter.frame = 2
	elif new_pos == "homerun":
		$Batter.frame = 5
	elif new_pos == "throw":
		$Pitcher.frame = 7
	else:
		printerr("could not find new_pos " + new_pos)

func reset() -> void:
	$Baseball.position.x = BaseballStartPos
	$Baseball.position.y = 319
	$Baseball.self_modulate.a = 0
	
	$Clouds.position.x = BackgroundStartPos
	
	$GaugeBall.position.x = GaugeBallStartPos
	$Background.position.x = BackgroundStartPos
	
	$Pitcher.position.x = PitcherStartPos
	$Batter.position.x = BatterStartPos
	change_sprites("ready")
	$Popup.self_modulate.a = 0
	
	BaseballXSpeed = 375
	BaseballYSpeed = 0
	
	if strikes == 0:
		$BallsContainer/Ball1.texture = ball_unused
		$BallsContainer/Ball2.texture = ball_unused
		$BallsContainer/Ball3.texture = ball_unused
	elif strikes == 1:
		$BallsContainer/Ball3.texture = ball_used
	elif strikes == 2:
		$BallsContainer/Ball2.texture = ball_used
	else:
		$BallsContainer/Ball1.texture = ball_used
		if Globals.high_scores["Batting"] < balls_scored:
			Globals.high_scores["Batting"] = balls_scored
		Globals.transition("MinigameHighScores")
	
	fading_state = -1
	bg_stopped = false
	frame_started = -1
	stopped = false
	
	hit_counter = 0
	ball_state = -1
		
	bb_moved = 0


func _ready() -> void:
	Globals.minigame = "BacchikoiBatting"
	$Baseball.self_modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Clouds.position.x += 25 * delta
	if $Clouds.position.x <= -BackgroundStartPos:
		$Clouds.position.x = BackgroundStartPos
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_SPACE):
		if frame_started == -1: frame_started = Engine.get_frames_drawn()
		if Engine.get_frames_drawn() > frame_started + 30 and not stopped:
			stopped = true
			var x_pos = $GaugeBall.position.x
			if x_pos <= 555 and x_pos >= 553:
				ball_state = 2
			elif x_pos > 548 && x_pos < 560:
				ball_state = 1
			else:
				ball_state = 0
			return
		else: 
			$Baseball.self_modulate.a = 1
			change_sprites("throw")
	if $Baseball.position.x >= 650 and fading_state < 0:
		if ball_state <= 0:
			strikes += 1
			if strikes == 1:
				$Popup.texture = PopupTextureStrike1
			elif strikes == 2:
				$Popup.texture = PopupTextureStrike2
			elif strikes == 3:
				$Popup.texture = PopupTextureStrike3
			else:
				$Popup.texture = PopupTextureOut
			if ball_state == 0:
				change_sprites("strike")
		elif ball_state == 1:
			balls_scored += 1
			
			$Popup.texture = PopupTextureSafe
			change_sprites("hit")
			
			BaseballXSpeed = -800
			BaseballYSpeed = -800
		elif ball_state == 2:
			balls_scored += 1
			
			$Popup.texture = PopupTextureHomerun
			change_sprites("homerun")
			
			BaseballXSpeed = -800
			BaseballYSpeed = -800
	
		fading_state = 0
		fading_counter = 0
	if (frame_started < 0): return
	
	if fading_state == 0:
		if $Popup.self_modulate.a < 1:
			$Popup.self_modulate.a += 0.01
		else:
			#print("FADED IN")
			fading_state = 1
	elif fading_state == 1:
		fading_counter += 1
		if fading_counter > Engine.get_frames_per_second() * 0.75:
			fading_state = 2
			#print("PAUSED")
	elif fading_state == 2:
		if $Popup.self_modulate.a > 0:
			$Popup.self_modulate.a -= 0.01
		else:
			fading_state = -1
			#print("FADED OUT")
			reset()
		
	if $GaugeBall.position.x <= GaugeBallEndPos and ball_state == -1:
		$GaugeBall.position.x += GaugeBallSpeed * delta
		
	if $Background.position.x >= BackgroundEndPos:
		$Background.position.x -= BackgroundSpeed * delta
		$Pitcher.position.x -= BackgroundSpeed * delta
		$Batter.position.x -= BackgroundSpeed * delta
		$Clouds.position.x += (BackgroundSpeed / 10) * delta
	else:
		bg_stopped = true
	if $GaugeBallStatic.self_modulate.a == 1 or $GaugeBallStatic.self_modulate.a <= 0:
		fade_mod *= -1
	$GaugeBallStatic.self_modulate.a += fade_mod
	
	if $Baseball.position.x <= BaseballEndPos:
		$Baseball.position.x += BaseballXSpeed * delta
		$Baseball.position.y += BaseballYSpeed * delta
	
		$Baseball.rotate(0.05)
		bb_moved += 1
		
	
