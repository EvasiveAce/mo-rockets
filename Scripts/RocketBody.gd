extends Node2D

export(Texture) var texture1
export(Texture) var texture2
export(Texture) var texture3

onready var rng = load("res://Scenes/RNG.tscn").instance()
onready var sprite = $RocketBodySprite

var nameString = ""
var nameString2 = ""
var statFloat = 0.0
var statFloat2 = 0.0
var spriteTexture

func _ready():
	randomize()
	modulate = rng._colorRandomize()
	sprite.texture = rng._textureRandomize(texture1, texture2, texture3)
	spriteTexture = sprite.texture
	nameString = rng._statsNameRandomize()
	nameString2 = rng._statsNameRandomize()
	statFloat = rng._statsAmountRandomize()
	statFloat2 = rng._statsAmountRandomize()
