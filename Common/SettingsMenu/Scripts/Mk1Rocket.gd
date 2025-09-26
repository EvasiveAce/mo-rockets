extends Panel

var changed = false
var stringVariableName := '???'

func _on_mouse_entered() -> void:
	await get_tree().create_timer(0.0001).timeout
	Popups.ItemPopup([stringVariableName, 'Reach 750m'], self)

func _on_mouse_exited() -> void:
	Popups.HideItemPopup()

func _process(_delta: float) -> void:
	if !changed and Constants.mk1PartsUpgrade:
		changed = true
		stringVariableName = 'Mark I Parts'
		$Mk1Sprite.texture = load('res://Rockets/Mk1Rocket/Sprites/Mk1Rocket.png')

