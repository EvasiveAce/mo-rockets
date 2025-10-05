extends Node2D


var recordFuncFinished = false
var switching = false
func _ready():
	var rocket = get_tree().root.get_node("Rocket")
	if rocket:
		# Reparent to new scene
		get_tree().root.remove_child(rocket)
		$RocketSubview/SubViewport.add_child(rocket)
		rocket.get_node("Sky").visible = true
		rocket.get_node("Moon").visible = true
		# Position as needed
		rocket.get_node("Camera2D").enabled = false
		rocket.position = Vector2(960,625)
		var anim_tree = $RocketSubview/SubViewport/Rocket/AnimationEnding/AnimationTree
		var state_machine = anim_tree.get("parameters/playback")
		anim_tree.active = true
		state_machine.travel('MoonLanding')
		await get_tree().create_timer(20.0).timeout
		if Constants.altitude > Constants.highestAltitude:
			Constants.highestAltitude = Constants.altitude
		_recordFunc()

func _process(_delta: float) -> void:
	if recordFuncFinished and !switching:
		if Input.is_action_just_pressed("ui_accept"):
			switching = true
			$RocketSubview/SubViewport/CanvasLayer2/AssemblyAnimationSprite.play("TransitionOut")
			await $RocketSubview/SubViewport/CanvasLayer2/AssemblyAnimationSprite.animation_finished
			if Constants.endText:
				get_tree().change_scene_to_file("res://Common/EndScene/Scenes/EndText.tscn")
			else:
				get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
			if Constants.highestAltitude == Constants.altitude:
				Constants.statMultiplier += .05
			else:
				Constants.statMultiplier += .01
			Constants.altitude = 0.0	

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch && event.is_pressed() and Constants.mobile and recordFuncFinished and !switching:
		switching = true
		$RocketSubview/SubViewport/CanvasLayer2/AssemblyAnimationSprite.play("TransitionOut")
		await $RocketSubview/SubViewport/CanvasLayer2/AssemblyAnimationSprite.animation_finished
		if Constants.endText:
			get_tree().change_scene_to_file("res://Common/EndScene/Scenes/EndText.tscn")
		else:
			get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
		if Constants.highestAltitude == Constants.altitude:
			Constants.statMultiplier += .05
		else:
			Constants.statMultiplier += .01
		Constants.altitude = 0.0	

func _recordFunc():
	# Legacy Fuel/Speed - Corroded Parts
	if (Constants.legacyFuel <= 0 and Constants.legacySpeed <= 0) and !Constants.corrodedPartsUpgrade:
		Constants.corrodedPartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Corroded Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/CorrodedRocket/Resources/CorrodedNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/CorrodedRocket/Resources/CorrodedBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/CorrodedRocket/Resources/CorrodedBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 750m - Mk. 1 Parts
	if Constants.altitude >= 750 and !Constants.mk1PartsUpgrade:
		Constants.mk1PartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Mk. 1 Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/Mk1Rocket/Resources/Mk1Nose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/Mk1Rocket/Resources/Mk1Body.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/Mk1Rocket/Resources/Mk1Bottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 1000m - Primary Paints
	if Constants.altitude >= 1000 and !Constants.primaryColorsUpgrade:
		Constants.primaryColorsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Primary Paints Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('0000ff'))
		Constants.colors.push_front(Color('00ff00'))
		Constants.colors.push_front(Color('ff0000'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 1987m - Springlocked Parts
	if Constants.altitude >= 1987 and !Constants.springLockedPartsUpgrade:
		Constants.springLockedPartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Springlocked Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/SpringlockedRocket/Resources/SpringlockedNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/SpringlockedRocket/Resources/SpringlockedBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/SpringlockedRocket/Resources/SpringlockedBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 2500m - Gameboy Paints
	if Constants.altitude >= 2500 and !Constants.retroColorsUpgrade:
		Constants.retroColorsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Gameboy Paints Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('8bac0f'))
		Constants.colors.push_front(Color('306230'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 5000m - Plastic Parts
	if Constants.altitude >= 5000 and !Constants.plasticPartsUpgrade:
		Constants.plasticPartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Plastic Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/PlasticRocket/Resources/PlasticNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/PlasticRocket/Resources/PlasticBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/PlasticRocket/Resources/PlasticBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 5 Launches - War Parts
	if Constants.amountOfLaunches >= 5 and !Constants.warPartsUpgrade:
		Constants.warPartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "War Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/WarRocket/Resources/WarNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/WarRocket/Resources/WarBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/WarRocket/Resources/WarBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 7500m - Best Browser Paints
	if Constants.altitude >= 7500 and !Constants.bestBrowserColorUpgrade:
		Constants.bestBrowserColorUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Best Browser Paints Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('ff9500'))
		Constants.colors.push_front(Color('ffcb00'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 10000m - Mouse Parts
	if Constants.altitude >= 10000 and !Constants.mousePartsUpgrade:
		Constants.mousePartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Mouse Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/MouseRocket/Resources/MouseNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/MouseRocket/Resources/MouseBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/MouseRocket/Resources/MouseBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 10 Launches - Alternative Paints
	if Constants.amountOfLaunches >= 10 and !Constants.alternativeColorsUpgrade:
		Constants.alternativeColorsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Alternative Paints Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('00ffff'))
		Constants.colors.push_front(Color('ffff00'))
		Constants.colors.push_front(Color('ff00ff'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 15000m - Mann Co. Paints
	if Constants.altitude >= 15000 and !Constants.mannCoColorsUpgrade:
		Constants.mannCoColorsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Mann Co. Paints Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('5b7a8c'))
		Constants.colors.push_front(Color('bd3b3b'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 15 Launches - Scrap Button
	if Constants.amountOfLaunches >= 15 and !Constants.scrapButtonEnabled:
		Constants.scrapButtonEnabled = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Scrap Button Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 25 Launches - Strange Parts
	if Constants.amountOfLaunches >= 25 and !Constants.strangePartsUpgrade:
		Constants.strangePartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Strange Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/StrangeRocket/Resources/StrangeNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/StrangeRocket/Resources/StrangeBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/StrangeRocket/Resources/StrangeBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 30000m - Cartoon Paints
	if Constants.altitude >= 30000 and !Constants.cartoonColorsUpgrade:
		Constants.cartoonColorsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Monster Paints Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('9c6a4a'))
		Constants.colors.push_front(Color('5082c0'))
		Constants.colors.push_front(Color('f8b0c8'))
		Constants.colors.push_front(Color('bd7bdd'))
		Constants.colors.push_front(Color('3fae40'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 50000m - Robot Parts
	if Constants.altitude >= 50000 and !Constants.robotPartsUpgrade:
		Constants.robotPartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Robot Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/RobotRocket/Resources/RobotNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/RobotRocket/Resources/RobotBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/RobotRocket/Resources/RobotBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 75000m - Crafty Paints
	if Constants.altitude >= 75000 and !Constants.notchedColorsUpgrade:
		Constants.notchedColorsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Crafty Paints Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('95c366'))
		Constants.colors.push_front(Color('4aedd9'))
		Constants.colors.push_front(Color('606060'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 100000m - Slim Parts
	if Constants.altitude >= 100000 and !Constants.slimPartsUpgrade:
		Constants.slimPartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Slim Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/SlimRocket/Resources/SlimNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/SlimRocket/Resources/SlimBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/SlimRocket/Resources/SlimBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 250000m - Galactic Parts
	if Constants.altitude >= 250000 and !Constants.galacticPartsUpgrade:
		Constants.galacticPartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Galactic Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/GalacticRocket/Resources/GalacticNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/GalacticRocket/Resources/GalacticBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/GalacticRocket/Resources/GalacticBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 500000m - Metallic Paints
	if Constants.altitude >= 500000 and !Constants.metallicColorsUpgrade:
		Constants.metallicColorsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Metallic Paints Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('c0c0c0'))
		Constants.colors.push_front(Color('c79f00'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 1000000m - Black Paint
	if Constants.altitude >= 1000000 and !Constants.blackColorUpgrade:
		Constants.blackColorUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Black Paint Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.colors.push_front(Color('0f0f0f'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	# 384399000m - Moon Parts & Endless Mode
	if Constants.altitude >= 384399000 and !Constants.moonPartsUpgrade:
		Constants.moonPartsUpgrade = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Moon Parts Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		Constants.noseParts.push_front(preload('res://Rockets/MoonRocket/Resources/MoonNose.tres'))
		Constants.bodyParts.push_front(preload('res://Rockets/MoonRocket/Resources/MoonBody.tres'))
		Constants.bottomParts.push_front(preload('res://Rockets/MoonRocket/Resources/MoonBottom.tres'))
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

		Constants.endlessMode = true
		$RocketSubview/SubViewport/PartsUnlocked.play()
		$RocketSubview/SubViewport/CanvasLayer/Parts.text = "Endless Mode Unlocked!"
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = true
		await get_tree().create_timer(1.0).timeout
		$RocketSubview/SubViewport/CanvasLayer/Parts.visible = false

	recordFuncFinished = true	
