extends UpgradeIcon

func _on_pressed() -> void:
	if Constants.research >= part.upgradeCost and part.unlockedBool and !part.boughtBool:
		Constants.research -= part.upgradeCost
		Constants[part.constantsName] = true
		part.boughtBool = Constants[part.constantsName]

		Constants.statMultiplier += .01
		Constants.bottomParts.push_front(part)

		$IconSprite.texture = part.boughtSprite
		line_2D.default_color = 'fcf8fc'
		$Select.play()