extends Control


@export var defaultFuel: float = 2
@export var defaultSpeed: float = 1 
@export var defaultWeight: float = -2.5

var tutorial = true

var stage = "NOSE"

var stats = []
var colors = [Color('ffffff')]
#fc3800 Color('fc3800'), Color('00a848'), Color('0000fc')
var noseParts = [preload('res://Rockets/BaseRocket/Resources/BaseNose.tres')]
var bodyParts = [preload('res://Rockets/BaseRocket/Resources/BaseBody.tres')]
var bottomParts = [preload('res://Rockets/BaseRocket/Resources/BaseBottom.tres')]

var modifiers = []

## UPGRADES ##

# Standard Rocket
var baseNoseUpgrade = true
var baseBodyUpgrade = true
var baseBottomUpgrade = true

# Mk. 1 Rocket
var mk1NoseUpgrade = false
var mk1BodyUpgrade = false
var mk1BottomUpgrade = false

# Modifier Upgrades
var speedTraitUpgrade
var fuelTraitUpgrade

## TOGGLES ##
var automation1 = false
##


var rocketNose
var rocketNoseModulate

var rocketBody
var rocketBodyModulate

var rocketBottom
var rocketBottomModulate

var fuel = 0.0
var speed = 0.0
var weight = 0.0

var highestAltitude = 0.0
var altitude = 0.0
var amountOfLaunches = 0

var partChoiceUpgrade = false
var automation1Upgrade = false
var rdBuildingUpgrade = false

var research = 0

func _determineTrait(part, partName, value : float):
	if part.StatType.keys()[partName] == part.StatType.keys()[part.StatType.SPEED]:
		speed += value
	elif part.StatType.keys()[partName] == part.StatType.keys()[part.StatType.FUEL]:
		fuel += value

func _addPart(part):
	if part.rocketPart.PartType.keys()[part.rocketPart.partType] == part.rocketPart.PartType.keys()[part.rocketPart.PartType.NOSE]:
		rocketNose = part.rocketPart
	elif part.rocketPart.PartType.keys()[part.rocketPart.partType] == part.rocketPart.PartType.keys()[part.rocketPart.PartType.BODY]:
		rocketBody = part.rocketPart
	else:
		rocketBottom = part.rocketPart
	
	_determineTrait(part.rocketPart, part.rocketPart.statModifier1Name, part.rocketPart.statModifier1Amount)
	_determineTrait(part.rocketPart, part.rocketPart.statModifier2Name, part.rocketPart.statModifier2Amount)

	if len(Constants.modifiers) > 0 and part.rocketModifier != null:
		
		_determineTrait(part.rocketModifier, part.rocketModifier.statModifier1Name, part.rocketModifier.statModifier1Amount)
		_determineTrait(part.rocketModifier, part.rocketModifier.statModifier2Name, part.rocketModifier.statModifier2Amount)
