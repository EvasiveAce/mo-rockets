extends Node2D

@onready var rocketNoseScene = preload("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
@onready var rocketBodyScene = preload("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
@onready var rocketBottomScene = preload("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
@onready var launchDetailScene = preload("res://Common/LaunchDetails/Scenes/LaunchDetails.tscn")


var noseScene
var bodyScene
var bottomScene
var launchScene

var inArea

@onready var rocketObject = preload("res://Common/World/RocketObject/Scenes/Rocket.tscn")

@onready var altitude
@onready var speed
@onready var fuel


@onready var firstTime = true
@onready var endEngaged = true
var switching = false
var recordFunc = false
var recordFuncFinished = false

var rocket
var camera2D
@onready var rocketAssembled = false

var abortReady = false

@onready var animation = $CanvasLayer2/AssemblyAnimationSprite

var shake_amount = 0.0
var shake_decay = 0.05

func _ready() -> void:
	if Constants.mobile:
		$CanvasLayer/MenuButton.visible = true
	%AbortLaunch.visible = false
	if Constants.scrapButtonEnabled:
		$ScrapRocket.visible = true
	$Ground/SkyParallax.scroll_base_offset.x = Constants.scrollbaseOffset
	$Ground/SkyParallax/ParallaxLayer.position.x = Constants.cloudPosition
	_initalizeRocket()
	var stringToUse = "%.2fx"
	$CanvasLayer/Multiplier/MultiplierValue.text = stringToUse % [Constants.statMultiplier]
	if Constants.highestAltitude >= 10000000000:
		$HighScore.text = str("10e%d" % (Constants.highestAltitude - 10000000000))
	else:
		$HighScore.text = str(Constants.highestAltitude) + ' m' if Constants.highestAltitude < 100000 else str(Constants.highestAltitude/1000.0) + ' km'
	if !Constants.initLoading:
		rocket.get_node('RocketParticles2').lifetime = .01
		rocket.get_node('RocketParticles2').amount = 1
		rocket.get_node('RocketParticles2').set_emitting(true)
		rocket.get_node('RocketExplodeParticles2').lifetime = .01
		rocket.get_node('RocketExplodeParticles2').amount = 1
		rocket.get_node('RocketExplodeParticles2').set_emitting(true)

		await rocket.get_node('RocketParticles2').finished
		await rocket.get_node('RocketExplodeParticles2').finished
		Constants.initLoading = true

	animation.play("TransitionIn")
	await animation.animation_finished
	Constants.transitioning = false

func _screen_shake():
	if camera2D and shake_amount > 0.0:
		shake_amount = max(shake_amount - shake_decay, 0.0)
		var shake_offset = Vector2(randf() - 0.5, randf() - 0.5) * shake_amount * 10.0
		camera2D.offset = shake_offset
	elif camera2D:
		camera2D.offset = Vector2.ZERO

func _process(_delta):

	if !rocket.grounded and abortReady:
		%AbortLaunch.visible = true
	else:
		%AbortLaunch.visible = false

	var altitude_limit_reached = false
	if Constants.altitude >= 384399000 and !Constants.endlessModeEnabled:
		altitude_limit_reached = true
		if rocket:
			rocket.set_process(false)
			rocket.position.y = -384399000
		Constants.altitude = 384399000
		altitude.text = '384399000m'
		Constants.scrollbaseOffset = $Ground/SkyParallax.scroll_base_offset.x
		Constants.cloudPosition = $Ground/SkyParallax/ParallaxLayer.position.x
		#await get_tree().create_timer(6).timeout
		remove_child(rocket)
		get_tree().root.add_child(rocket)
		get_tree().change_scene_to_file("res://Common/EndScene/Scenes/EndScene.tscn")
		

		
	elif Constants.altitude < 384399000 or !altitude_limit_reached:
		

		_screen_shake()

		if rocketAssembled:
			speed = get_node("CanvasLayer/Speed/SpeedValue")
			fuel = get_node("CanvasLayer/Fuel/FuelValue")
			altitude = get_node("CanvasLayer/Altitude")
			speed.text = str(rocket.speedToUse)
			fuel.text = str(snapped(rocket.fuelToUse, 0.01))
			if Constants.endlessModeEnabled and rocket.launching:
				var distance_this_frame = snapped((rocket.speedToUse * (1.0 + (rocket.speedToUse / Constants.fuelConsumptionRate)) * _delta * 60), 1)
				Constants.altitude += distance_this_frame
				if Constants.altitude >= 10000000000 or Constants.infinities > 0:
					if Constants.altitude >= 10000000000:
						Constants.altitude = 1
						Constants.infinities += 1
						altitude.text = str("10e%d" % [Constants.infinities])
					else:
						altitude.text = str("10e%d" % [Constants.infinities])
				elif Constants.altitude >= 1000000000 and Constants.infinities == 0:
					altitude.text = str(Constants.altitude/1000000000) + "gm"
				elif Constants.altitude >= 10000000 and Constants.infinities == 0:
					altitude.text = str(Constants.altitude/1000000) + "mm"
				elif Constants.altitude >= 100000 and Constants.infinities == 0:
					altitude.text = str(Constants.altitude/1000) + "km"
				elif Constants.infinities == 0:
					altitude.text = str(Constants.altitude) + "m"
			elif !Constants.endlessModeEnabled:
				if (rocket.position.y - 625) * -1 >= Constants.altitude:
					Constants.altitude = snapped((rocket.position.y - 625) * -1, 1)
					if Constants.altitude >= 100000:
						altitude.text = str(Constants.altitude/1000) + "km"
					else:
						altitude.text = str(Constants.altitude) + "m"
			elif Constants.endlessModeEnabled and Constants.infinities < 1 and Constants.altitude == 0.0:
				altitude.text = str(Constants.altitude) + "m"

			if rocket.reachedHeight and Constants.endlessModeEnabled and endEngaged:
				$CanvasLayer/ParallaxBackground.scroll_base_offset.y += 50 * (1.0 + (100 / Constants.fuelConsumptionRate)) * _delta * 60
			
			if (Input.is_action_just_released("ui_accept") and firstTime):
				$ScrapRocket.visible = false
				rocket._blastOff()
				shake_amount = 3.5
				set_timer()
				firstTime = false
			if Constants.endlessModeEnabled and !rocket.launching and !firstTime and endEngaged:
				rocket._explode()
				Constants.altitude = 10000000000 + Constants.infinities
				if Constants.altitude > Constants.highestAltitude:
					Constants.highestAltitude = Constants.altitude
				endEngaged = false
			_endGame()
			_recordFunc()
			if !endEngaged and !switching and recordFuncFinished:
				if Input.is_action_just_pressed("ui_accept"):
					Constants.scrollbaseOffset = $Ground/SkyParallax.scroll_base_offset.x
					Constants.cloudPosition = $Ground/SkyParallax/ParallaxLayer.position.x
					switching = true
					Constants.transitioning = true
					animation.play("TransitionOut")
					await animation.animation_finished
					get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
					rocketAssembled = false
					if Constants.highestAltitude == Constants.altitude:
						Constants.statMultiplier += .05
					else:
						Constants.statMultiplier += .01
					Constants.altitude = 0.0
					Constants.infinities = 0

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch && event.is_pressed() and Constants.mobile and firstTime and inArea:
		$ScrapRocket.visible = false
		rocket._blastOff()
		shake_amount = 3.5
		set_timer()
		firstTime = false
	if !endEngaged and !switching and recordFuncFinished:
		if event is InputEventScreenTouch && event.is_pressed() and Constants.mobile:
			Constants.scrollbaseOffset = $Ground/SkyParallax.scroll_base_offset.x
			Constants.cloudPosition = $Ground/SkyParallax/ParallaxLayer.position.x
			switching = true
			Constants.transitioning = true
			animation.play("TransitionOut")
			await animation.animation_finished
			get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
			rocketAssembled = false
			if Constants.highestAltitude == Constants.altitude:
				Constants.statMultiplier += .05
			else:
				Constants.statMultiplier += .01
			Constants.altitude = 0.0
			Constants.infinities = 0

func set_timer():
	await get_tree().create_timer(5.75).timeout
	if !rocket.grounded:
		abortReady = true
		%AbortLaunch.visible = true

func _recordFunc():
	if !recordFunc && !endEngaged:
		recordFunc = true
		# High Score
		if Constants.highestAltitude == Constants.altitude:
			$Record.play()
			$CanvasLayer/Record.visible = true
			await get_tree().create_timer(.25).timeout
			$CanvasLayer/Record.visible = false
			await get_tree().create_timer(.25).timeout
			$CanvasLayer/Record.visible = true
			await get_tree().create_timer(.25).timeout
			$CanvasLayer/Record.visible = false
			await get_tree().create_timer(.25).timeout
			$CanvasLayer/Record.visible = true
			await get_tree().create_timer(.25).timeout

		# Legacy Fuel/Speed - Corroded Parts
		if (Constants.legacyFuel <= 0 and Constants.legacySpeed <= 0) and !Constants.corrodedPartsUpgrade:
			Constants.corrodedPartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Corroded Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/CorrodedRocket/Resources/CorrodedNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/CorrodedRocket/Resources/CorrodedBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/CorrodedRocket/Resources/CorrodedBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 750m - Mk. I Parts
		if Constants.altitude >= 750 and !Constants.mk1PartsUpgrade:
			Constants.mk1PartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Mark I Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/Mk1Rocket/Resources/Mk1Nose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/Mk1Rocket/Resources/Mk1Body.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/Mk1Rocket/Resources/Mk1Bottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 1000m - Primary Paints
		if Constants.altitude >= 1000 and !Constants.primaryColorsUpgrade:
			Constants.primaryColorsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Primary Paints Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('0000ff'))
			Constants.colors.push_front(Color('00ff00'))
			Constants.colors.push_front(Color('ff0000'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 1987m - Springlocked Parts
		if Constants.altitude >= 1987 and !Constants.springLockedPartsUpgrade:
			Constants.springLockedPartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Springlocked Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/SpringlockedRocket/Resources/SpringlockedNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/SpringlockedRocket/Resources/SpringlockedBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/SpringlockedRocket/Resources/SpringlockedBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 2500m - Gameboy Paints
		if Constants.altitude >= 2500 and !Constants.retroColorsUpgrade:
			Constants.retroColorsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Gameboy Paints Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('8bac0f'))
			Constants.colors.push_front(Color('306230'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 5000m - Plastic Parts
		if Constants.altitude >= 5000 and !Constants.plasticPartsUpgrade:
			Constants.plasticPartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Plastic Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/PlasticRocket/Resources/PlasticNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/PlasticRocket/Resources/PlasticBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/PlasticRocket/Resources/PlasticBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 5 Launches - War Parts
		if Constants.amountOfLaunches >= 5 and !Constants.warPartsUpgrade:
			Constants.warPartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "War Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/WarRocket/Resources/WarNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/WarRocket/Resources/WarBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/WarRocket/Resources/WarBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 7500m - Best Browser Paints
		if Constants.altitude >= 7500 and !Constants.bestBrowserColorUpgrade:
			Constants.bestBrowserColorUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Best Browser Paints Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('ff9500'))
			Constants.colors.push_front(Color('ffcb00'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 10000m - Mouse Parts
		if Constants.altitude >= 10000 and !Constants.mousePartsUpgrade:
			Constants.mousePartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Mouse Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/MouseRocket/Resources/MouseNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/MouseRocket/Resources/MouseBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/MouseRocket/Resources/MouseBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 10 Launches - Alternative Paints
		if Constants.amountOfLaunches >= 10 and !Constants.alternativeColorsUpgrade:
			Constants.alternativeColorsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Alternative Paints Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('00ffff'))
			Constants.colors.push_front(Color('ffff00'))
			Constants.colors.push_front(Color('ff00ff'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 15000m - Mann Co. Paints
		if Constants.altitude >= 15000 and !Constants.mannCoColorsUpgrade:
			Constants.mannCoColorsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Mann Co. Paints Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('5b7a8c'))
			Constants.colors.push_front(Color('bd3b3b'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 15 Launches - Scrap Button
		if Constants.amountOfLaunches >= 15 and !Constants.scrapButtonEnabled:
			Constants.scrapButtonEnabled = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Scrap Button Unlocked!"
			$CanvasLayer/Parts.visible = true
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 25 Launches - Strange Parts
		if Constants.amountOfLaunches >= 25 and !Constants.strangePartsUpgrade:
			Constants.strangePartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Strange Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/StrangeRocket/Resources/StrangeNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/StrangeRocket/Resources/StrangeBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/StrangeRocket/Resources/StrangeBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 30000m - Cartoon Paints
		if Constants.altitude >= 30000 and !Constants.cartoonColorsUpgrade:
			Constants.cartoonColorsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Monster Paints Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('9c6a4a'))
			Constants.colors.push_front(Color('5082c0'))
			Constants.colors.push_front(Color('f8b0c8'))
			Constants.colors.push_front(Color('bd7bdd'))
			Constants.colors.push_front(Color('3fae40'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 50000m - Robot Parts
		if Constants.altitude >= 50000 and !Constants.robotPartsUpgrade:
			Constants.robotPartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Robot Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/RobotRocket/Resources/RobotNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/RobotRocket/Resources/RobotBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/RobotRocket/Resources/RobotBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 75000m - Crafty Paints
		if Constants.altitude >= 75000 and !Constants.notchedColorsUpgrade:
			Constants.notchedColorsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Crafty Paints Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('95c366'))
			Constants.colors.push_front(Color('4aedd9'))
			Constants.colors.push_front(Color('606060'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 100000m - Slim Parts
		if Constants.altitude >= 100000 and !Constants.slimPartsUpgrade:
			Constants.slimPartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Slim Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/SlimRocket/Resources/SlimNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/SlimRocket/Resources/SlimBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/SlimRocket/Resources/SlimBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 250000m - Galactic Parts
		if Constants.altitude >= 250000 and !Constants.galacticPartsUpgrade:
			Constants.galacticPartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Galactic Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/GalacticRocket/Resources/GalacticNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/GalacticRocket/Resources/GalacticBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/GalacticRocket/Resources/GalacticBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 500000m - Metallic Paints
		if Constants.altitude >= 500000 and !Constants.metallicColorsUpgrade:
			Constants.metallicColorsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Metallic Paints Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('c0c0c0'))
			Constants.colors.push_front(Color('c79f00'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 1000000m - Black Paint
		if Constants.altitude >= 1000000 and !Constants.blackColorUpgrade:
			Constants.blackColorUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Black Paint Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.colors.push_front(Color('0f0f0f'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

		# 384399000m - Moon Parts & Endless Mode
		if Constants.altitude >= 384399000 and !Constants.moonPartsUpgrade:
			Constants.moonPartsUpgrade = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Moon Parts Unlocked!"
			$CanvasLayer/Parts.visible = true
			Constants.noseParts.push_front(preload('res://Rockets/MoonRocket/Resources/MoonNose.tres'))
			Constants.bodyParts.push_front(preload('res://Rockets/MoonRocket/Resources/MoonBody.tres'))
			Constants.bottomParts.push_front(preload('res://Rockets/MoonRocket/Resources/MoonBottom.tres'))
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false

			Constants.endlessMode = true
			$PartsUnlocked.play()
			$CanvasLayer/Parts.text = "Endless Mode Unlocked!"
			$CanvasLayer/Parts.visible = true
			await get_tree().create_timer(1.0).timeout
			$CanvasLayer/Parts.visible = false
			

		recordFuncFinished = true		


func _initalizeRocket():
	rocket = rocketObject.instantiate()
	rocket.noseTexture = Constants.rocketNose.partSprite
	rocket.noseModulate = Constants.rocketNose.modulate
	rocket.bodyTexture = Constants.rocketBody.partSprite
	rocket.bodyModulate = Constants.rocketBody.modulate
	rocket.bottomTexture = Constants.rocketBottom.partSprite
	rocket.bottomModulate = Constants.rocketBottom.modulate
	rocket.position.x = 960
	rocket.position.y = 625
	add_child(rocket)
	rocketAssembled = true
	camera2D = Camera2D.new()
	camera2D.enabled = true
	camera2D.name = 'Camera2D'
	camera2D.limit_enabled = false
	camera2D.position.x = 0
	camera2D.position.y = -85
	rocket.add_child(camera2D)


func _endGame():
	if !firstTime and rocket.position.y >= 600 and !rocket.launching and endEngaged:
		rocket.position.y = 600
		rocket._explode()
		if Constants.altitude > Constants.highestAltitude:
			Constants.highestAltitude = Constants.altitude
		endEngaged = false


func _on_scrap_rocket_pressed() -> void:
	$ScrapRocketSound.play()
	Constants.scrollbaseOffset = $Ground/SkyParallax.scroll_base_offset.x
	Constants.cloudPosition = $Ground/SkyParallax/ParallaxLayer.position.x
	switching = true
	Constants.transitioning = true
	animation.play("TransitionOut")
	await animation.animation_finished
	get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
	rocketAssembled = false


func _on_abort_launch_pressed() -> void:
	rocket.launching = false
	abortReady = false
	rocket.grounded = true
	%AbortLaunch.visible = false
	rocket._explode()
	if Constants.endlessModeEnabled and !rocket.launching and !firstTime and endEngaged:
		Constants.altitude = 10000000000 + Constants.infinities
		if Constants.altitude > Constants.highestAltitude:
			Constants.highestAltitude = Constants.altitude
	else:
		if Constants.altitude > Constants.highestAltitude:
			Constants.highestAltitude = Constants.altitude
	endEngaged = false
	_recordFunc()


func _on_menu_button_pressed() -> void:
	if !Constants.transitioning:
		Settings._show_settings()



func _on_mobile_click_mouse_exited() -> void:
	inArea = false

func _on_mobile_click_mouse_entered() -> void:
	inArea = true
