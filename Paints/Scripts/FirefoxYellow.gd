extends Panel

var changed = false
var stringVariableName := '???'

func _on_mouse_entered() -> void:
	await get_tree().create_timer(0.0001).timeout
	Popups.ItemPopup([stringVariableName, 'Reach 7500m'], self)

func _on_mouse_exited() -> void:
	Popups.HideItemPopup()

func _process(_delta: float) -> void:
	if !changed and Constants.bestBrowserColorUpgrade:
		changed = true
		stringVariableName = 'Firefox Yellow Paint'
		$LockedSprite.texture = load('res://Paints/Sprites/FireFoxYellow.png')
