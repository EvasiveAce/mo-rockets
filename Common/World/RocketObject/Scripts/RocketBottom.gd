extends Node2D

@onready var rng = load("res://Common/RNG/Scenes/RNG.tscn").instantiate()
@onready var sprite = $RocketBottomSprite

var rocketPart: RocketPart
var rocketModifier: Modifier

func _ready():
	randomize()
	rocketPart = rng._randomizeBottomPart()
	rocketModifier = rng._randomizeModifier()
	#modulate = rng._colorRandomize()
	sprite.texture = rocketPart.partSprite
	# nameString = rng._statsNameRandomize()
