extends Node

@export var speed: int = 100
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var bg_texture = load("res://data/" + Globals.selected_character + "/bg.png")
	$Background1.texture = bg_texture
	$Background2.texture = bg_texture
	
	if Globals.selected_character == "skip":
		$Lights1.visible = true
		$Lights2.visible = true
		$Stars1.visible = true
		$Stars2.visible = true
	elif Globals.selected_character == "dew":
		$Rain1.visible = true
		$Rain2.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Background1.position.x -= speed * delta + owner.speed_addition;
	$Background2.position.x -= speed * delta + owner.speed_addition;
	
	if $Background1.position.x <= -400:
		$Background1.position.x = 800 + $Background2.position.x
	
	if $Background2.position.x <= -400:
		$Background2.position.x = 800 + $Background1.position.x

	if $Lights1.visible:
		$Lights1.position.x -= speed * delta + owner.speed_addition;
		$Lights2.position.x -= speed * delta + owner.speed_addition;
		
		if $Lights1.position.x <= -400:
			$Lights1.position.x = 800 + $Lights2.position.x
		
		if $Lights2.position.x <= -400:
			$Lights2.position.x = 800 + $Lights1.position.x
	if $Stars1.visible:
		$Stars1.position.x -= speed * delta + owner.speed_addition;
		$Stars2.position.x -= speed * delta + owner.speed_addition;
		
		if $Stars1.position.x <= -400:
			$Stars1.position.x = 800 + $Stars2.position.x
		
		if $Stars2.position.x <= -400:
			$Stars2.position.x = 800 + $Stars1.position.x	
	if $Rain1.visible:
		$Rain1.position.x -= speed * delta + owner.speed_addition;
		$Rain2.position.x -= speed * delta + owner.speed_addition;
		
		if $Rain1.position.x <= -400:
			$Rain1.position.x = 800 + $Rain2.position.x
		
		if $Rain2.position.x <= -400:
			$Rain2.position.x = 800 + $Rain1.position.x

func _physics_process(_delta: float) -> void:
	counter += 1
	@warning_ignore("integer_division")
	var frame_value = counter / 5 
		
	$Rain1.frame = frame_value % 4
	$Rain2.frame = frame_value % 4
	$Lights1.frame = frame_value % 9
	$Lights2.frame = frame_value % 9
	$Stars1.frame = frame_value % 13
	$Stars2.frame = frame_value % 13
