extends Node2D

@onready var rng = load("res://Common/RNG/Scenes/RNG.tscn").instantiate()
@onready var sprite = $RocketBottomSprite

var rocketPart: RocketPart

func _ready():
	randomize()
	rocketPart = rng._randomizeBottomPart()
	rocketPart.modulate = rng._colorRandomize()
	sprite.texture = rocketPart.partSprite
	# nameString = rng._statsNameRandomize()
