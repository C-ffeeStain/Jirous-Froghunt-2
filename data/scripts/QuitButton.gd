extends Button

var audio_player: AudioStreamPlayer
var click_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuClick.wav")
var hover_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuSelected.wav")

func _ready() -> void:
	audio_player = owner.get_node("AudioStreamPlayer")
	if Globals.sfx_volume > 0:
		audio_player.volume_db = linear_to_db(Globals.sfx_volume)
		pressed.connect(on_pressed)
		mouse_entered.connect(on_mouse_entered)
	else:
		pressed.connect(get_tree().quit)

func on_pressed() -> void:
	audio_player.stream = click_sound
	audio_player.play()
	audio_player.finished.connect(get_tree().quit)

func on_mouse_entered() -> void:
	audio_player.stream = hover_sound
	audio_player.play()
