extends Button

@export var scene: String
var click_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuClick.wav")
var hover_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuSelected.wav")
var audio_player: AudioStreamPlayer
@export var sound_effects = true

func _ready() -> void:	
	audio_player = owner.get_node("AudioStreamPlayer")

	if Globals.sfx_volume == 0: sound_effects = false
	else: audio_player.volume_db = linear_to_db(Globals.sfx_volume)
	
	
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)
	

func on_pressed() -> void:
	if sound_effects:
		audio_player.stream = click_sound
		audio_player.play()
	change_scene()
		

func change_scene():
	Globals.transition(scene)

func on_mouse_entered() -> void:
	if !sound_effects: return
	audio_player.stream = hover_sound
	audio_player.play()
