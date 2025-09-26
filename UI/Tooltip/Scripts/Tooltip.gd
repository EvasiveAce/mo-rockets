extends CanvasLayer

func ItemPopup(item, node):
	# Get current mouse position
	var node_global_pos = node.global_position
	var node_size = node.size

	# Update popup content
	%Main/MarginContainer/VBoxContainer/Name.text = item[0]
	%Main/MarginContainer/VBoxContainer/Information.text = item[1]
	
	# Calculate popup position
	var viewport_size = get_viewport().get_visible_rect().size
	var popup_pos = Vector2()
	popup_pos.x = node_global_pos.x + (node_size.x / 2) - (%Main.size.x / 2)
	popup_pos.y = node_global_pos.y - %Main.size.y - 10  # 10px above node
	
	_font_determine()

	# Set final position
	%Main.size = Vector2(324,88)
	%Main.position = popup_pos
	visible = true

func HideItemPopup():
	visible = false

func _font_determine():
	var stringLength = %Name.text.length()
	if stringLength < 14:
		%Name.add_theme_font_size_override('font_size', 32)
	elif stringLength < 23:
		%Name.add_theme_font_size_override('font_size', 24)
	else:
		%Name.add_theme_font_size_override('font_size', 16)
