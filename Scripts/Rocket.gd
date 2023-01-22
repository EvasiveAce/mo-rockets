extends KinematicBody2D

onready var timer = $RocketTimer
onready var particles = $RocketParticles


onready var topSprite = $TopSprite
onready var bodySprite = $BodySprite
onready var bottomSprite = $BottomSprite

var noseTexture
var noseModulate
var bodyTexture
var bodyModulate
var bottomTexture
var bottomModulate


export(float) var fuelToUse = 0.0
export(float) var speedToUse = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	topSprite.texture = noseTexture
	bodySprite.texture = bodyTexture
	bottomSprite.texture = bottomTexture
	topSprite.modulate = noseModulate
	bodySprite.modulate = bodyModulate
	bottomSprite.modulate = bottomModulate
	particles.modulate = bottomModulate
	_setUp()

#func _movement():
#	if Input.is_action_pressed("ui_left"):
#		position.x -= aeroToUse
#	elif Input.is_action_pressed("ui_right"):
#		position.x += aeroToUse


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#_movement()
	if !timer.is_stopped():
		position.y -= speedToUse
		fuelToUse = timer.time_left
	else:
		particles.set_emitting(false)
		$Rocket.stop()
		if position.y <= 625 and fuelToUse <= 0:
			position.y += speedToUse * 2

func _blastOff():
	$RocketLaunch.play()
	particles.set_emitting(true)
	timer.start()
	$Rocket.play()

func _setUp():
	if Constants.fuel > 0:
		fuelToUse = Constants.defaultFuel +  Constants.fuel
	else:
		fuelToUse = Constants.defaultFuel * 1
	if Constants.speed > 0:
		speedToUse = Constants.defaultSpeed + Constants.speed
	else:
		speedToUse = Constants.defaultSpeed * 1
	timer.wait_time = fuelToUse


func _on_RocketTimer_timeout():
	fuelToUse = 0.0
