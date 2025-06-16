extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var total = Globals.total_frogs
	
	if total < 5: return
	if total >= 5:
		$SkipButton.disabled = false
		$UnlockSkip.visible = false
	if total >= 20:
		$MilkButton.disabled = false
		$UnlockMilk.visible = false
	if total >= 40:
		$AshButton.disabled = false
		$UnlockAsh.visible = false
	if total >= 69:
		$DewButton.disabled = false
		$UnlockDew.visible = false
	
	get_parent().get_child(5).text = str(total)
