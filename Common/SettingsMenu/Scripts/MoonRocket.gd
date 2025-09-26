extends Panel

var changed = false
var stringVariableName := '???'

func _on_mouse_entered() -> void:
	await get_tree().create_timer(0.0001).timeout
	Popups.ItemPopup([stringVariableName, 'Reach the Moon!'], self)

func _on_mouse_exited() -> void:
	Popups.HideItemPopup()

func _process(_delta: float) -> void:
	if !changed and Constants.moonPartsUpgrade:
		changed = true
		stringVariableName = 'Moon Parts'
		$MoonSprite.texture = load('res://Rockets/MoonRocket/Sprites/MoonRocket.png')

