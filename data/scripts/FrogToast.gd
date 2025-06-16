extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var frogs = Globals.frogs_this_run
	if frogs == 1:
		text = "You collected 1 frog!"
	else:
		text = "You collected " + str(Globals.frogs_this_run) + " frogs!"
		
	Globals.total_frogs += frogs
	Globals.frogs_this_run = 0
	Globals.save_data()
	
