extends Control


var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func _colorRandomize():
	return Constants.colors[randi() % Constants.colors.size()]

func _randomizeNosePart():
	if !Constants.noseParts.is_empty():
		return Constants.noseParts[randi() % Constants.noseParts.size()]

func _randomizeBodyPart():
	if !Constants.bodyParts.is_empty():
		return Constants.bodyParts[randi() % Constants.bodyParts.size()]

func _randomizeBottomPart():
	if !Constants.bottomParts.is_empty():
		return Constants.bottomParts[randi() % Constants.bottomParts.size()]

func _textureBodyRandomize():
	return load(Constants.bodyTextures[randi() % Constants.bodyTextures.size()])

func _textureBottomRandomize():
	return load(Constants.bottomTextures[randi() % Constants.bottomTextures.size()])

func _statsNameRandomize():
	return Constants.stats[randi() % Constants.stats.size()] if !Constants.stats.is_empty() else ''

func _statsAmountRandomize():
	return (randf_range((-.5), (.5)) + (Constants.RDBuildingAmount * 0.05) + (Constants.ArtBuildingAmount * .10))

func _randomizeModifier():
	if !Constants.modifiers.is_empty():
		if randf() < 0.25:
			return null
		else:
			return Constants.modifiers[randi() % Constants.modifiers.size()]
	else:
		return null