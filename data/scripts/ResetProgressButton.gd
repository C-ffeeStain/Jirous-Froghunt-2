extends Button


var click_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuClick.wav")
var hover_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuSelected.wav")
var audio_player: AudioStreamPlayer
@export var sound_effects = true

func _ready() -> void:
	audio_player = owner.get_node("AudioStreamPlayer")
	
	if Globals.sfx_volume == 0: sound_effects = false
	
	if sound_effects: mouse_entered.connect(on_mouse_entered)
	else: audio_player.volume_db = linear_to_db(Globals.sfx_volume)
	
	pressed.connect(on_pressed)

func on_pressed() -> void:
	if sound_effects:
		audio_player.stream = click_sound
		audio_player.play()
	Globals.total_frogs = 0
	Globals.save_data()
	

func on_mouse_entered() -> void:
	audio_player.stream = hover_sound
	audio_player.play()	
