extends Button

var click_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuClick.wav")
var hover_sound: AudioStreamWAV = preload("res://data/sfx/mainMenuSelected.wav")
@onready var audio_player: AudioStreamPlayer = get_node("/root/Music/AudioStreamPlayer")
@onready var music_player: AudioStreamPlayer = get_node("/root/Music/MusicPlayer")
@export var character: String = "jirou"
@export var options: Array[String] = ["Normal"]
@export var sound_effects = true

@onready var song_variants: OptionButton = get_parent().get_node("SongVariants")

func _ready() -> void:		
	if Globals.sfx_volume == 0: sound_effects = false
	
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)
	
func on_pressed() -> void:
	Globals.selected_character = character
	song_variants.clear()
	for option in options:
		song_variants.add_item(option)
		
	music_player.stream = song_variants.PathTable[character]["Normal"]
	if sound_effects:
		audio_player.stream = click_sound
		audio_player.play()

	music_player.stop()
	get_parent().get_node("PlayButton").text = "Play"

func on_mouse_entered() -> void:
	if (disabled): return
	audio_player.stream = hover_sound
	audio_player.play()
