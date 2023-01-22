extends Control


var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func _colorRandomize():
	var colors = [Color.red,
	Color.blue,
	Color.green,
	Color.blueviolet,
	Color.gold,
	Color.slategray]
	return colors[randi() % colors.size()]

func _textureRandomize(texture1 : Texture, texture2 : Texture, texture3 : Texture):
	var sprites = [texture1, texture2, texture3]
	return sprites[randi() % sprites.size()]

func _statsNameRandomize():
	return Constants.stats[randi() % Constants.stats.size()]

func _statsAmountRandomize():
	return rand_range((-.5 * (Constants.highestAltitude / 1000.0)), (.5 * (Constants.highestAltitude / 1000.0)))
