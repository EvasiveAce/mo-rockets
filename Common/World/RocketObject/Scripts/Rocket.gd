extends CharacterBody2D

@onready var timer = $RocketTimer
@onready var particles = $RocketParticles


@onready var topSprite = $TopSprite
@onready var bodySprite = $BodySprite
@onready var bottomSprite = $BottomSprite

var noseTexture
var noseModulate
var bodyTexture
var bodyModulate
var bottomTexture
var bottomModulate


@export var fuelToUse: float = 0.0
@export var speedToUse: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	topSprite.texture = noseTexture
	bodySprite.texture = bodyTexture
	bottomSprite.texture = bottomTexture
	# topSprite.modulate = noseModulate
	# bodySprite.modulate = bodyModulate
	# bottomSprite.modulate = bottomModulate
	# particles.modulate = bottomModulate
	_setUp()

#func _movement():
#	if Input.is_action_pressed("ui_left"):
#		position.x -= aeroToUse
#	elif Input.is_action_pressed("ui_right"):
#		position.x += aeroToUse


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#_movement()
	if !timer.is_stopped():
		position.y -= speedToUse
		fuelToUse = timer.time_left
		$Rocket.play()
	else:
		if position.y >= 600 and fuelToUse <= 0.0:
			$Camera2D.enabled = false
		particles.set_emitting(false)
		$Rocket.stop()
		if position.y <= 600 and fuelToUse <= 0:
			position.y += speedToUse * 4


func _blastOff():
	Constants.amountOfLaunches += 1
	$RocketLaunch.play()
	particles.set_emitting(true)
	timer.start()
	$Rocket.play()

func _setUp():
	fuelToUse = Constants.defaultFuel + Constants.fuel
	speedToUse = Constants.defaultSpeed + Constants.speed
	speedToUse = snappedf(speedToUse, 0.01)
	fuelToUse = snappedf(fuelToUse, 0.01)
	timer.wait_time = fuelToUse
	Constants.speed = 0.0
	Constants.fuel = 0.0


func _on_RocketTimer_timeout():
	fuelToUse = 0.0

func _explode():
	$TopSprite.visible = false
	$BodySprite.visible = false
	$BottomSprite.visible = false
	$RocketExplodeParticles.set_emitting(true)
