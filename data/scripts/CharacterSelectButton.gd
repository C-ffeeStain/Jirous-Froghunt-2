extends Button

@export var scene: String
var click_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuClick.wav")
var hover_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuSelected.wav")
var audio_player: AudioStreamPlayer
@export var character: String = "jirou"
@export var sound_effects = true

var original_z_index

func _ready() -> void:
	audio_player = owner.get_node("AudioStreamPlayer")
	original_z_index = z_index
	
	if Globals.sfx_volume == 0: sound_effects = false
	
	if sound_effects:
		pressed.connect(on_pressed)
		mouse_entered.connect(on_mouse_entered)
		mouse_exited.connect(on_mouse_exited)
	else: pressed.connect(change_scene)

func on_pressed() -> void:
	Globals.selected_character = character
	if sound_effects:
		audio_player.stream = click_sound
		audio_player.finished.connect(change_scene)
		audio_player.play()
	else: change_scene()
		

func change_scene() -> void:
	Globals.transition(scene)

func on_mouse_entered() -> void:
	if (disabled): return
	z_index = 99
	audio_player.stream = hover_sound
	audio_player.play()

func on_mouse_exited() -> void:
	z_index = original_z_index
