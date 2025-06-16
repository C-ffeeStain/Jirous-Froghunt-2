extends OptionButton

var MusicPlayer: AudioStreamPlayer

var PathTable: Dictionary = {
		"jirou":
			{
				"Normal": preload("res://data/jirou/normal.wav")
			},
		"skip":
			{
				"Normal": preload("res://data/skip/normal.wav"),
				"Sad": preload("res://data/skip/sad.mp3"),
			},
		"milk":
			{
				"Normal": preload("res://data/milk/normal.wav"),
				"Piano": preload("res://data/milk/piano.mp3"),
				"Sad": preload("res://data/milk/sad.mp3"),
			},
		"ash":
			{
				"Normal": preload("res://data/ash/normal.wav"),
				"Casual": preload("res://data/ash/casual.mp3"),
				"Extended": preload("res://data/ash/extended.mp3"),
				"Sad": preload("res://data/ash/sad.mp3"),
			},
		"dew":
			{
				"Normal": preload("res://data/dew/normal.wav")
			}
		}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer = owner.get_node("MusicPlayer")
	
	MusicPlayer.finished.connect(MusicPlayer.play)
	
	item_selected.connect(on_item_selected)

func on_item_selected(index: int):
	var text2 = get_item_text(index)
	
	MusicPlayer.stream = PathTable[Globals.selected_character][text2]
