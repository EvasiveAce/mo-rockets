extends Node2D

@onready var rocketNoseScene = load("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
@onready var rocketBodyScene = load("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
@onready var rocketBottomScene = load("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
@onready var launchDetailScene = load("res://Common/LaunchDetails/Scenes/LaunchDetails.tscn")


var noseScene
var bodyScene
var bottomScene
var launchScene

@onready var rocketObject = preload("res://Common/World/RocketObject/Scenes/Rocket.tscn")

@onready var altitude
@onready var speed
@onready var fuel


@onready var firstTime = true
@onready var endEngaged = true

var rocket
var camera2D
@onready var rocketAssembled = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.stage_finished.connect(_stage_finished)

func _process(_delta):
	$Research/ResearchValue.text = str(Constants.research)

	if Constants.automation1Upgrade and !$AutomationToggle.visible:
		$AutomationToggle.show()

	if rocketAssembled:
		if !Constants.automation1 and firstTime:
			get_node("AssemblyViewport/SubViewport/LaunchDetails/Control/Press").show()
		speed = get_node("AssemblyViewport/SubViewport/LaunchDetails/Control/Speed/SpeedValue")
		fuel = get_node("AssemblyViewport/SubViewport/LaunchDetails/Control/Fuel/FuelValue")
		altitude = get_node("AssemblyViewport/SubViewport/LaunchDetails/Control/Altitude/AltitudeValue")
		speed.text = str(rocket.speedToUse)
		fuel.text = str(snapped(rocket.fuelToUse, 0.01))
		if (rocket.position.y - 625) * -1 >= Constants.altitude:
			if Constants.altitude < 1000:
				Constants.altitude = snapped((rocket.position.y - 625) * -1, 1)
				altitude.text = str(Constants.altitude) + "m"
			else:
				Constants.altitude = (rocket.position.y - 625) * -1
				altitude.text = str(snapped((float((Constants.altitude) / 1000)), .1)) + "km"
		if (Input.is_action_just_released("ui_accept") and firstTime) or (Constants.automation1 and firstTime):
			get_node("AssemblyViewport/SubViewport/LaunchDetails/Control/Press").hide()
			rocket._blastOff()
			firstTime = false
		_endGame()
		if !endEngaged:
			if !Constants.automation1:
				get_node("AssemblyViewport/SubViewport/LaunchDetails/Control/PressAssemble").show()
				get_node("AssemblyViewport/SubViewport/LaunchDetails/Control/ResearchPointsAwarded").show()
				get_node("AssemblyViewport/SubViewport/LaunchDetails/Control/ResearchPointsAwarded/ResearchPointValue").text = str(snapped((Constants.altitude / 100), 1))
			if Input.is_action_just_pressed("ui_accept") or Constants.automation1:
				Constants.research += snapped((Constants.altitude / 100), 1)
				$AssemblyViewport/SubViewport.remove_child($AssemblyViewport/SubViewport/LaunchDetails)
				endEngaged = true
				firstTime = true
				rocketAssembled = false
				noseScene = rocketNoseScene.instantiate()
				noseScene.name = 'AssemblyNose'
				$AssemblyViewport/SubViewport.add_child(noseScene)
				Constants.altitude = 0.0

func _stage_finished():
	if Constants.stage == "NOSE":
		_nose_finished()
	elif Constants.stage == "BODY":
		_body_finished()
	elif Constants.stage == "BOTTOM":
		_bottom_finished()

func _nose_finished():
	Constants.stage = "BODY"
	var rocketToRemove = $RocketSubview/SubViewport/RocketControl.get_node_or_null("Rocket")
	if rocketToRemove:
		$RocketSubview/SubViewport/RocketControl.remove_child(rocketToRemove)

	$AssemblyViewport/SubViewport.remove_child($AssemblyViewport/SubViewport/AssemblyNose)
	bodyScene = rocketBodyScene.instantiate()
	bodyScene.name = 'AssemblyBody'
	$AssemblyViewport/SubViewport.add_child(bodyScene)

func _body_finished():
	Constants.stage = "BOTTOM"
	$AssemblyViewport/SubViewport.remove_child($AssemblyViewport/SubViewport/AssemblyBody)
	bottomScene = rocketBottomScene.instantiate()
	bottomScene.name = 'AssemblyBottom'
	$AssemblyViewport/SubViewport.add_child(bottomScene)

func _bottom_finished():
	Constants.stage = "NOSE"
	$AssemblyViewport/SubViewport.remove_child($AssemblyViewport/SubViewport/AssemblyBottom)
	launchScene = launchDetailScene.instantiate()
	launchScene.name = 'LaunchDetails'
	$AssemblyViewport/SubViewport.add_child(launchScene)

	_initalizeRocket()



func _initalizeRocket():
	rocket = rocketObject.instantiate()
	rocket.noseTexture = Constants.rocketNose.partSprite
	rocket.noseModulate = Constants.rocketNoseModulate
	rocket.bodyTexture = Constants.rocketBody.partSprite
	rocket.bodyModulate = Constants.rocketBodyModulate
	rocket.bottomTexture = Constants.rocketBottom.partSprite
	rocket.bottomModulate = Constants.rocketBottomModulate
	rocket.position.x = 656
	rocket.position.y = 625
	$RocketSubview/SubViewport/RocketControl.add_child(rocket)
	rocketAssembled = true
	camera2D = Camera2D.new()
	camera2D.enabled = true
	camera2D.name = 'Camera2D'
	#camera2D.make_current()
	camera2D.position.x = 30
	camera2D.position.y = -85
	rocket.add_child(camera2D)


func _endGame():
	if !firstTime and rocket.position.y >= 600 and rocket.timer.is_stopped() and endEngaged:
		if Constants.altitude > Constants.highestAltitude:
			Constants.highestAltitude = Constants.altitude
		endEngaged = false
		rocket._explode()


# func _on_automation_toggle_toggled(toggled_on:bool) -> void:
# 	if !toggled_on:
# 		Constants.automation1 = true
# 		$AutomationToggle/Sprite.texture = automationOnSprite
# 		$AutomationToggle/Select.play()
# 	else:
# 		Constants.automation1 = false
# 		$AutomationToggle/Sprite.texture = automationOffSprite
# 		$AutomationToggle/Select.play()
