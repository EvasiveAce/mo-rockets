extends Control

func ItemPopup(item):
	# Get current mouse position
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Update popup content
	%ItemPopup/MarginContainer/VBoxContainer/Name.text = item[0]
	%ItemPopup/MarginContainer/VBoxContainer/Price.text = str(item[2]) + " Research"
	%ItemPopup/MarginContainer/VBoxContainer/Description.text = item[3]
	%ItemPopup/MarginContainer/VBoxContainer/Information.text = item[1].c_unescape()
	
	# Calculate popup position
	var viewport_size = get_viewport().get_visible_rect().size
	var popup_pos = Vector2i(mouse_pos)
	
	# Add a small offset from cursor
	popup_pos += Vector2i(20, 20)
	
	# Make sure it stays on screen
	if (popup_pos.x + %ItemPopup.size.x) > viewport_size.x:
		popup_pos.x = mouse_pos.x - %ItemPopup.size.x - 20
	
	if (popup_pos.y + %ItemPopup.size.y) > viewport_size.y:
		popup_pos.y = mouse_pos.y - %ItemPopup.size.y - 20
		
	# Set final position
	%ItemPopup.popup(Rect2i(popup_pos, %ItemPopup.size))

func HideItemPopup():
	%ItemPopup.hide()
