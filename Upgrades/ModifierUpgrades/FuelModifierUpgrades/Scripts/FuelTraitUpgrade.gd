extends UpgradeIcon

func _on_pressed() -> void:
	if Constants.research >= part.upgradeCost and part.unlockedBool and !part.boughtBool:
		Constants.research -= part.upgradeCost
		Constants[part.constantsName] = true
		part.boughtBool = Constants[part.constantsName]
		for modifier in part.modifiersToAdd:
			Constants.modifiers.push_front(modifier)
		$IconSprite.texture = part.boughtSprite
		line_2D.default_color = 'fcf8fc'
		$Select.play()
