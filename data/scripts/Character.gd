extends CharacterBody2D

var ducking: bool = false
var appliedDuckingHitbox: bool = false
@export var jump_speed = -1000
var gravity = 2500

var frames_at_start: int

@onready var AudioPlayer = $AudioStreamPlayer
@onready var AnimPlayer = $Sprite/AnimationPlayer

func _ready() -> void:
	frames_at_start = Engine.get_frames_drawn()
	
	Globals.frogs_this_run = 0
	$Sprite.texture = load("res://data/" + Globals.selected_character + "/player.png")
	 
	AudioPlayer.volume_db = linear_to_db(Globals.sfx_volume)

func get_input():
	var jump = Input.is_action_just_pressed('ui_select') or Input.is_action_just_pressed("ui_up")
	if is_on_floor() and jump:
		velocity.y = jump_speed
		AudioPlayer.play()

func _physics_process(delta):
	if Engine.get_frames_drawn() > frames_at_start + 15:
		if not is_on_floor():
			AnimPlayer.play("Jump", -1, 1.5)
		elif Input.is_action_pressed("ui_down"):
			AnimPlayer.play("Duck")
		else:
			AnimPlayer.play("Run")
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	
