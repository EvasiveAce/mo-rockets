extends Node2D

onready var rocketObject = preload("res://Scenes/Rocket.tscn")

onready var animation = $AssemblyAnimationSprite

onready var rocketNose = Constants.rocketNose
onready var rocketNoseModulate = Constants.rocketNoseModulate
onready var rocketBody = Constants.rocketBody
onready var rocketBodyModulate = Constants.rocketBodyModulate
onready var rocketBottom = Constants.rocketBottom
onready var rocketBottomModulate = Constants.rocketBottomModulate

onready var fuelLeft = $CanvasLayer/Control/FuelLeft/FuelLeftValue
onready var speed = $CanvasLayer/Control/Speed/SpeedValue
onready var altitude = $CanvasLayer/Control/Altitude/AltitudeValue
onready var record = $CanvasLayer/Record

onready var firstTime = true
onready var endEngaged = true

var rocket
var camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	
	
	rocket = rocketObject.instance()
	rocket.noseTexture = rocketNose
	rocket.noseModulate = rocketNoseModulate
	rocket.bodyTexture = rocketBody
	rocket.bodyModulate = rocketBodyModulate
	rocket.bottomTexture = rocketBottom
	rocket.bottomModulate = rocketBottomModulate
	rocket.position.x = 960
	rocket.position.y = 625
	$RocketControl.add_child(rocket)
	camera2D = Camera2D.new()
	camera2D.current = true
	camera2D.position.x = 0
	camera2D.position.y = -100
	rocket.add_child(camera2D)


func _process(delta):
	speed.text = str(stepify(rocket.speedToUse, 0.1))
	fuelLeft.text = str(stepify(rocket.fuelToUse, 0.1))
	if (rocket.position.y - 625) * -1 >= Constants.altitude:
		Constants.altitude = stepify((rocket.position.y - 625) * -1, 1)
		altitude.text = str(Constants.altitude) + "ft"
	if Input.is_action_just_released("ui_accept") and firstTime:
		$CanvasLayer/Control/Press.hide()
		rocket._blastOff()
		firstTime = false
	_endGame()
	if !endEngaged:
		if Input.is_action_just_pressed("ui_accept"):
			animation.play("TransitionOut")
			yield(animation, "animation_finished")
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
			Constants.altitude = 0.0

func _endGame():
	if !firstTime and rocket.position.y >= 625 and rocket.timer.is_stopped() and endEngaged:
		endEngaged = false
		$CanvasLayer/Control/Press.visible = true
		$CanvasLayer/Control/Press.text = "Press Space to Scrap"
		if Constants.altitude > Constants.highestAltitude:
			Constants.highestAltitude = Constants.altitude
			$Record.play()
			record.visible = true
			$AnimationTimer.start(1.0)
			yield($AnimationTimer, "timeout")
			record.visible = false
			$AnimationTimer.start(1.0)
			yield($AnimationTimer, "timeout")
			record.visible = true
			$AnimationTimer.start(1.0)
			yield($AnimationTimer, "timeout")
			record.visible = false
			$AnimationTimer.start(1.0)
			yield($AnimationTimer, "timeout")
			record.visible = true
		if !record.visible:
			$NoRecord.play()
