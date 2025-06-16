extends CharacterBody2D

@export var speed: float = -500

var frames_at_start: int

@onready var Sprite: Sprite2D = $Sprite
@onready var AnimPlayer = $Sprite/AnimationPlayer
@onready var AudioPlayer = $AudioStreamPlayer

func _ready() -> void:
	frames_at_start = Engine.get_frames_drawn()
	
	Sprite.texture = load("res://data/" + Globals.selected_character + "/frog.png")
	
	AudioPlayer.volume_db = linear_to_db(Globals.sfx_volume)

func _physics_process(delta):
	if Engine.get_frames_drawn() > frames_at_start + 15:
		AnimPlayer.play("FrogHop")
	var collision_data = move_and_collide(Vector2(speed + owner.speed_addition, 0) * delta)
	if collision_data:
		Globals.frogs_this_run += 1
		position.x = 800
		AudioPlayer.play()
	if position.x < -400: # loop around
		position.x = 800
