extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SnakeScoreLabel.text = str(Globals.high_scores["Snake"])
	$BattingScoreLabel.text = str(Globals.high_scores["Batting"])
	$FroggerScoreLabel.text = str(Globals.high_scores["Frogger"])
	
	$BackButton.scene = Globals.minigame
