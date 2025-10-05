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

var fauxSpeed = 50.0

var launching = false
var grounded = false

var reachedHeight = false

@export var fuelToUse: float = 0.0
var fuelToRecord: float = 0.0

@export var speedToUse: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if noseTexture and noseModulate and bodyTexture and bodyModulate and bottomTexture and bottomModulate:
		topSprite.texture = noseTexture
		bodySprite.texture = bodyTexture
		bottomSprite.texture = bottomTexture
		topSprite.modulate = noseModulate
		bodySprite.modulate = bodyModulate
		bottomSprite.modulate = bottomModulate

		var gradient = Gradient.new()

		gradient.add_point(0, bottomModulate)
		gradient.add_point(.36, bodyModulate)
		gradient.add_point(.72, noseModulate)

		gradient.remove_point(0)
		gradient.remove_point(0)

		var gradientTexture = GradientTexture1D.new()
		gradientTexture.set_gradient(gradient)
		gradient.interpolation_mode = 1

		# Set the gradient
		particles.process_material.set_color_ramp(gradientTexture)
		_setUp()

#func _movement():
#	if Input.is_action_pressed("ui_left"):
#		position.x -= aeroToUse
#	elif Input.is_action_pressed("ui_right"):
#		position.x += aeroToUse


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#_movement()
	if $RocketSoundTimer.time_left > 0:
		$Rocket.play()

	var fuel_consumption_rate
	var distance_gain_rate
	if fuelToUse > 0 and launching:
		if Constants.endlessModeEnabled and $RocketSoundTimer.time_left > 0:
			fuel_consumption_rate = 1.0 + (speedToUse / Constants.fuelConsumptionRate)
			distance_gain_rate = fauxSpeed * fuel_consumption_rate
			position.y -= fauxSpeed * (1.0 + (fauxSpeed / Constants.fuelConsumptionRate)) * _delta * 60
			fuelToUse = max(0.0, fuelToUse - fuel_consumption_rate * _delta)
		elif Constants.endlessModeEnabled and $RocketSoundTimer.time_left == 0:
			reachedHeight = true
			fuel_consumption_rate = 1.0 + (speedToUse / Constants.fuelConsumptionRate)
			fuelToUse = max(0.0, fuelToUse - fuel_consumption_rate * _delta)
		elif !Constants.endlessModeEnabled:
			fuel_consumption_rate = 1.0 + (speedToUse / Constants.fuelConsumptionRate)
			distance_gain_rate = speedToUse * fuel_consumption_rate
			position.y -= distance_gain_rate * _delta * 60
			fuelToUse = max(0.0, fuelToUse - fuel_consumption_rate * _delta)
	else:
		launching = false
		if Constants.endlessModeEnabled:
			$Rocket.stop()
			particles.set_emitting(false)
			if fuelToUse <= 0.0:
				grounded = true
				reachedHeight = false
		else:
			if position.y >= 600 and fuelToUse <= 0.0:
				grounded = true
				$Camera2D.enabled = false
				particles.set_emitting(false)
			$Rocket.stop()
			if position.y <= 600 and fuelToUse <= 0 and !grounded:
				position.y += speedToUse * 4


func _blastOff():
	Constants.amountOfLaunches += 1
	$RocketLaunch.play()
	particles.set_emitting(true)
	launching = true
	$RocketSoundTimer.start()
	
func _setUp():
	fuelToUse = (Constants.defaultFuel + Constants.fuel) * Constants.statMultiplier
	fuelToUse = clamp(fuelToUse, Constants.defaultFuel, 9223372036854775807)
	speedToUse = (Constants.defaultSpeed + Constants.speed) * Constants.statMultiplier
	speedToUse = clamp(speedToUse, Constants.defaultSpeed, 9223372036854775807)
	speedToUse = snappedf(speedToUse, 0.01)
	fuelToUse = snappedf(fuelToUse, 0.01)
	fuelToRecord = fuelToUse
	timer.wait_time = fuelToUse
	Constants.legacySpeed = Constants.speed
	Constants.legacyFuel = Constants.fuel
	Constants.speed = 0.0
	Constants.fuel = 0.0


func _on_RocketTimer_timeout():
	fuelToUse = 0.0

func _explode():
	launching = false
	$TopSprite.visible = false
	$BodySprite.visible = false
	$BottomSprite.visible = false
	if _hasWarParts():
		$RocketExplodeParticles.amount = 500
		$RocketExplodeHigh.play()
	elif fuelToRecord >= ((Constants.highestAltitude) / 500.0):
		$RocketExplodeParticles.amount = 50
		$RocketExplodeMedium.play()
	else:
		$RocketExplodeParticles.amount = 25
		$RocketExplodeLow.play()

	$RocketExplodeParticles.set_emitting(true)

func _hasWarParts() -> bool:
	return (noseTexture and "war" in noseTexture.resource_path.to_lower()) or \
		   (bodyTexture and "war" in bodyTexture.resource_path.to_lower()) or \
		   (bottomTexture and "war" in bottomTexture.resource_path.to_lower())


func _on_rocket_particles_finished() -> void:
	$Rocket.stop()
