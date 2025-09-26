extends Panel

var changed = false
var stringVariableName := '???'

func _on_mouse_entered() -> void:
	await get_tree().create_timer(0.0001).timeout
	Popups.ItemPopup([stringVariableName, 'Launch 25 Rockets'], self)

func _on_mouse_exited() -> void:
	Popups.HideItemPopup()

func _process(_delta: float) -> void:
	if !changed and Constants.strangePartsUpgrade:
		changed = true
		stringVariableName = 'Strange Parts'
		$StrangeSprite.texture = load('res://Rockets/StrangeRocket/Sprites/StrangeRocket.png')

