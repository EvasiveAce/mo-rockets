extends Panel


func _on_mouse_entered() -> void:
	await get_tree().create_timer(0.0001).timeout
	Popups.ItemPopup(['Standard Parts', 'Unlocked by Default'], self)

func _on_mouse_exited() -> void:
	Popups.HideItemPopup()
