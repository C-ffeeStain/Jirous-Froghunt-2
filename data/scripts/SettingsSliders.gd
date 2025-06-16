extends Control

var sfx_slider: HSlider
var music_slider: HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	sfx_slider = $SFXVolumeSlider
	music_slider = $MusicVolumeSlider
	
	sfx_slider.value = Globals.sfx_volume
	music_slider.value = Globals.music_volume
	
	sfx_slider.value_changed.connect(sfx_slider_changed)
	music_slider.value_changed.connect(music_slider_changed)

func sfx_slider_changed(value: float):
	Globals.sfx_volume = value
	Globals.save_data()
	
	var ResetProgress = get_parent().get_node("ResetProgress")
	var ReturnButton = get_parent().get_node("ReturnButton")
	
	ResetProgress.audio_player.volume_db = linear_to_db(value)
	ReturnButton.audio_player.volume_db = linear_to_db(value)
	if value != 0:
		ReturnButton.sound_effects = true
		ResetProgress.sound_effects = true
	else:
		ReturnButton.sound_effects = false
		ResetProgress.sound_effects = false

func music_slider_changed(value: float):
	if value == 0:
		Globals.music_player.stop()
	elif Globals.music_volume == 0 and value > 0:
		Globals.music_player.play()

	Globals.music_volume = value
	Globals.music_player.volume_db = linear_to_db(value)
	Globals.save_data()
