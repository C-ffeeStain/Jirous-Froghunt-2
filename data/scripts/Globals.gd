extends Node

var frogs_this_run: int = 0
var total_frogs: int = 0

var selected_character: String = "jirou"

var sfx_volume: float = 1.0
var music_volume: float = 1.0

var last_screen = "MainMenu"

var playback_position: float = 0

var music_player: AudioStreamPlayer

var minigame = ""

var config_file: ConfigFile

var high_scores: Dictionary

func _ready() -> void:
	
	config_file = ConfigFile.new()
	load_data()
	save_data()
	
	music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://data/" + selected_character + "/normal.wav")
	add_child(music_player)
	
	music_player.finished.connect(music_player.play)
	
	if music_volume > 0: music_player.play()

func transition(screen_name: String):
	var screen_filename = "res://data/screens/" + screen_name + ".tscn"
	if screen_name == "Game" and last_screen == "CharacterSelect":
		music_player.stream = load("res://data/" + selected_character + "/normal.wav")
		music_player.stop()
		music_player.play()
	if (screen_name == "MainMenu" and last_screen == "GameOver") or last_screen == "Music":
		music_player.stream = load("res://data/jirou/normal.wav")
		music_player.stop()
		music_player.play()
	if screen_name == "Music":
		music_player.stop()
	if screen_name == "BacchikoiBatting":
		music_player.stream = load("res://data/minigames/bkoi/batting_music.mp3")
		music_player.stop()
		music_player.play()
	if last_screen == "BacchikoiBatting":
		music_player.stream = load("res://data/jirou/normal.wav")
		music_player.stop()
		music_player.play()
	save_data()
	get_tree().change_scene_to_file(screen_filename)
	last_screen = screen_name

func save_data() -> void:
	config_file.set_value("Settings", "music_volume", music_volume)
	config_file.set_value("Settings", "sfx_volume", sfx_volume)
	config_file.set_value("Game", "total_frogs", total_frogs)
	config_file.set_value("Minigames", "high_scores", high_scores)
	
	config_file.save("user://savedata.cfg")
	

func load_data() -> void:
	var err = config_file.load("user://savedata.cfg")
	
	if err != OK:
		return
		
	total_frogs = config_file.get_value("Game", "total_frogs", 0)
	music_volume = config_file.get_value("Settings", "music_volume", 1.0)
	sfx_volume = config_file.get_value("Settings", "sfx_volume", 1.0)
	high_scores = config_file.get_value("Minigames", "high_scores", {
		"Batting": 0,
		"Frogger": 0,
		"Snake": 0,
		"LaserGame": 0
	})

func _process(_delta: float) -> void:
	music_player.volume_db = linear_to_db(music_volume)
