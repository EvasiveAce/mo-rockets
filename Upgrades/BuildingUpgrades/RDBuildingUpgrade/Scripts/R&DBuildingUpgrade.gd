extends UpgradeIcon



func _process(_delta: float) -> void:
    if Constants.highestAltitude >= 250 and !part.boughtBool:
        part.unlockedBool = true
        $IconSprite.texture = part.iconSprite
    

func _on_pressed() -> void:
    if Constants.research >= part.upgradeCost and part.unlockedBool and !part.boughtBool:
        Constants.research -= part.upgradeCost
        Constants[part.constantsName] = true
        part.boughtBool = Constants[part.constantsName]
        $IconSprite.texture = part.boughtSprite
        line_2D.default_color = 'fcf8fc'
        $Select.play()