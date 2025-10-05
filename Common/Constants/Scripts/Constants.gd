extends Control


@export var defaultFuel: float = 3.5
@export var defaultSpeed: float = 3.0

var tutorial = true
var endText = true

var transitioning = false

var fuelConsumptionRate = 50.0

var stage = "NOSE"

var cloudPosition := 224.0
var scrollbaseOffset := 0.0


var colors = [Color('ffffff')]

var noseParts = [preload('res://Rockets/BaseRocket/Resources/BaseNose.tres')]
var bodyParts = [preload('res://Rockets/BaseRocket/Resources/BaseBody.tres')]
var bottomParts = [preload('res://Rockets/BaseRocket/Resources/BaseBottom.tres')]

## DATA
var highestAltitude := 1000
var altitude = 0.0
var infinities = 0.0
var amountOfLaunches := 0
var statMultiplier = 1.00

var initLoading = false

var mobile = false

func _ready() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		mobile = true

## UPGRADES ##

# Endless Mode
var endlessMode = false
var endlessModeEnabled = false

# Scrap Button
var scrapButtonEnabled = false

# Colors
var primaryColorsUpgrade = false
var alternativeColorsUpgrade = false
var retroColorsUpgrade = false
var bestBrowserColorUpgrade = false
var mannCoColorsUpgrade = false
var cartoonColorsUpgrade = false
var notchedColorsUpgrade = false
var metallicColorsUpgrade = false
var blackColorUpgrade = false

# War Parts
var warPartsUpgrade = false

# Springlocked Parts
var springLockedPartsUpgrade = false

# Mk. 1 Rocket
var mk1PartsUpgrade = false

# Plastic Rocket
var plasticPartsUpgrade = false

# Mouse Rocket
var mousePartsUpgrade = false

# Corroded Rocket
var corrodedPartsUpgrade = false

# Robot Rocket
var robotPartsUpgrade = false

# Strange Rocket
var strangePartsUpgrade = false

# Slim Rocket
var slimPartsUpgrade = false

# Galactic Rocket
var galacticPartsUpgrade = false

# Moon Rocket
var moonPartsUpgrade = false

var rocketNose
var rocketNoseModulate
var rocketNoseValue

var rocketBody
var rocketBodyModulate
var rocketBodyValue

var rocketBottom
var rocketBottomModulate
var rocketBottomValue

var fuel = 0.0
var speed = 0.0

var legacySpeed = 0.0
var legacyFuel = 0.0

func _addPart(part, partValue):
	if part.rocketPart.PartType.keys()[part.rocketPart.partType] == part.rocketPart.PartType.keys()[part.rocketPart.PartType.NOSE]:
		rocketNose = part.rocketPart
	elif part.rocketPart.PartType.keys()[part.rocketPart.partType] == part.rocketPart.PartType.keys()[part.rocketPart.PartType.BODY]:
		rocketBody = part.rocketPart
	else:
		rocketBottom = part.rocketPart
	
	Constants.speed += partValue[0]
	Constants.fuel += partValue[1]

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('pause') and !transitioning:
		Settings._show_settings()
		

func _save():
	var nosePartsArray = []
	var bodyPartsArray = []
	var bottomPartsArray = []
	var colorsArray = []
	for part in noseParts:
		if part != null:
			nosePartsArray.append(part.resource_path)
	
	for part in bodyParts:
		if part != null:
			bodyPartsArray.append(part.resource_path)
	
	for part in bottomParts:
		if part != null:
			bottomPartsArray.append(part.resource_path)
	
	for color in colors:
		if color != null:
			colorsArray.append(color.to_html())

	var save_dict = {
		'tutorial' : tutorial,
		'cloudPosition' : cloudPosition,
		'scrollbaseOffset' : scrollbaseOffset,
		'colors' : colorsArray,
		'noseParts' : nosePartsArray,
		'bodyParts' : bodyPartsArray,
		'bottomParts' : bottomPartsArray,
		'highestAltitude' : highestAltitude,
		'amountOfLaunches' : amountOfLaunches,
		'statMultiplier' : statMultiplier,
		'endlessMode' : endlessMode,
		'endlessModeEnabled' : endlessModeEnabled,
		'scrapButtonEnabled' : scrapButtonEnabled,
		'primaryColorsUpgrade' : primaryColorsUpgrade,
		'alternativeColorsUpgrade' : alternativeColorsUpgrade,
		'retroColorsUpgrade' : retroColorsUpgrade,
		'bestBrowserColorUpgrade' : bestBrowserColorUpgrade,
		'mannCoColorsUpgrade' : mannCoColorsUpgrade,
		'cartoonColorsUpgrade' : cartoonColorsUpgrade,
		'notchedColorsUpgrade' : notchedColorsUpgrade, 
		'metallicColorsUpgrade' : metallicColorsUpgrade,
		'blackColorUpgrade' : blackColorUpgrade,
		'mk1PartsUpgrade' : mk1PartsUpgrade,
		'warPartsUpgrade' : warPartsUpgrade,
		'springLockedPartsUpgrade' : springLockedPartsUpgrade,
		'plasticPartsUpgrade' : plasticPartsUpgrade,
		'mousePartsUpgrade' : mousePartsUpgrade,
		'corrodedPartsUpgrade' : corrodedPartsUpgrade,
		'robotPartsUpgrade' : robotPartsUpgrade,
		'strangePartsUpgrade' : strangePartsUpgrade,
		'slimPartsUpgrade' : slimPartsUpgrade,
		'galacticPartsUpgrade' : galacticPartsUpgrade,
		'moonPartsUpgrade' : moonPartsUpgrade
	}
	return save_dict

func _export_game():
	var save_data = _save()
	var json_string = JSON.stringify(save_data)
	var base64 = Marshalls.utf8_to_base64(json_string)
	return base64

func _import_game(baseString : String):
	var decodedData = JSON.parse_string(Marshalls.base64_to_utf8(baseString))
	if decodedData == null:
		return false
	else:
		for i in decodedData.keys():
			if i == 'noseParts':
				noseParts = []
				for path in decodedData[i]:
					noseParts.append(load(path))
			elif i == 'bodyParts':
				bodyParts = []
				for path in decodedData[i]:
					bodyParts.append(load(path))
			elif i == 'bottomParts':
				bottomParts = []
				for path in decodedData[i]:
					bottomParts.append(load(path))
			elif i == 'colors':
				colors = []
				for path in decodedData[i]:
					colors.append(Color(path))
			else:
				Constants.set(i, decodedData[i])
		return true

func _play_out():
	$AudioStreamPlayerOut.play()
