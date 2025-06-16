extends CharacterBody2D

var madeNoise: bool = false
var speed: float
var enemy_type: String = "Snake"

var snake_texture: CompressedTexture2D
var raven_texture: CompressedTexture2D
var snake_hiss = preload("res://data/sfx/snakeHiss.wav")
var raven_caw = preload("res://data/sfx/hawkScreech.wav")

var frames_at_start: int

@onready var Sprite: Sprite2D = $Sprite
@onready var AnimPlayer = $Sprite/AnimationPlayer
@onready var AudioPlayer = $AudioStreamPlayer

func set_enemy_type(type):
	enemy_type = type
	madeNoise = false
	if type == "Raven":
		Sprite.texture = raven_texture
		AudioPlayer.stream = raven_caw
		if randi_range(1, 10) > 3:
			position.y = 200
		else: position.y = 337
		
		$Hitbox.position = Vector2(-1, 6)
		$Hitbox.shape.size = Vector2(129, 98)
	else:
		Sprite.texture = snake_texture
		AudioPlayer.stream = snake_hiss
		position.y = 337
		$Hitbox.position = Vector2(3, 32)
		$Hitbox.shape.size = Vector2(99, 57)
		

func _ready() -> void:
	frames_at_start = Engine.get_frames_drawn()
	
	snake_texture = load("res://data/" + Globals.selected_character + "/snake.png")
	raven_texture = load("res://data/" + Globals.selected_character + "/raven.png")
	
	set_enemy_type(enemy_type)

	if Globals.selected_character == "jirou":
		speed = -450
	elif Globals.selected_character == "skip":
		speed = -550
	elif Globals.selected_character == "milk":
		speed = -650
	elif Globals.selected_character == "ash":
		speed = -750
	elif Globals.selected_character == "dew":
		speed = -850
	
	AudioPlayer.volume_db = linear_to_db(Globals.sfx_volume)

func _physics_process(delta):
	speed -= 10 * delta + owner.speed_addition
	if Engine.get_frames_drawn() > frames_at_start + 15:
		AnimPlayer.play("EnemyMove")
	var collision_data = move_and_collide(Vector2(speed, 0) * delta)
	if collision_data:
		if collision_data.get_collider().name != "Ground":
			position.x = 800 + randi_range(1, 100)
			Globals.transition("GameOver")
	
	if !madeNoise:
		AudioPlayer.play()
		madeNoise = true
	if position.x < -400: # loop around
		position.x  = 850
		if randi_range(1, 10) >= 5:
			set_enemy_type("Snake")
		else:
			set_enemy_type("Raven")
		madeNoise = false
