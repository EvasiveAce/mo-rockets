extends Node2D

@onready var assemblySprite = load("res://Common/AssemblyStage/Sprites/AssemblyScreen.png")
@onready var assemblySpriteNoUpgrade = load("res://Common/AssemblyStage/Sprites/AssemblyScreenDefault.png")

@onready var partObject
@onready var text = $AssemblyLabel
@onready var animation = $AssemblyAnimationSprite

@onready var button1 = $AssemblyButton1

@onready var button2 = $AssemblyButton2

@onready var button3 = $AssemblyButton3

var part1
var part2
var part3

var part1Value : Array
var part2Value : Array
var part3Value : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	if Constants.endlessMode:
		$EndlessButton.visible = true
		$EndlessButton.disabled = false
		if Constants.endlessModeEnabled:
			$EndlessButton.toggled.disconnect(_on_button_toggled)
			$EndlessButton.button_pressed = true
			$EndlessButton.toggled.connect(_on_button_toggled)
			$EndlessButton.modulate = '00ff00'
	_checkStage()
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	text.text = "CHOOSE A " + Constants.stage
	part1 = partObject.instantiate()
	part2 = partObject.instantiate()
	part3 = partObject.instantiate()
	add_child(part1)
	add_child(part2)
	add_child(part3)

	_fillOutButton(button1, part1, part1Value)
	_fillOutButton(button2, part2, part2Value)
	_fillOutButton(button3, part3, part3Value)
	await animation.animation_finished
	Constants.transitioning = false

func _checkStage():
	if Constants.stage == "NOSE":
		partObject = load("res://Common/World/RocketObject/Scenes/RocketNose.tscn")
	elif Constants.stage == "BODY":
		partObject = load("res://Common/World/RocketObject/Scenes/RocketBody.tscn")
	elif Constants.stage == "BOTTOM":
		partObject = load("res://Common/World/RocketObject/Scenes/RocketBottom.tscn")

func _clear_container(container : VBoxContainer) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

func _fillOutButton(button : Button, part, partValue):
	var speedArray = []
	var fuelArray = []
	var speedValue : float = 0.0
	var fuelValue : float = 0.0

	var trait_vbox = button.get_node("AssemblyNameBox")
	var number_vbox = button.get_node("AssemblyStatsBox")
	
	_clear_container(trait_vbox)
	_clear_container(number_vbox)

	for i in range(2):
		var random_trait = randi() % 2  # 0 for speed, 1 for fuel
		var modifier_value
		
		# Get modifier value from part
		if i == 0:
			modifier_value = part.rocketPart._get_stat1_modifier()
		else:
			modifier_value = part.rocketPart._get_stat2_modifier()
		
		match random_trait:
			0:  # speedStat
				speedArray.push_front({"Part" : modifier_value})
			1:  # fuelStat
				fuelArray.push_front({"Part" : modifier_value})

	
	if len(speedArray) > 0:
		for value in speedArray:
			speedValue += value.values()[0]

		var mainLabel = Label.new()
		var mainNumberLabel = Label.new()
		mainLabel.label_settings = preload("res://Data/Resources/LabelSettings.tres")
		mainNumberLabel.label_settings = preload("res://Data/Resources/LabelSettings.tres")
		mainLabel.text = "SPEED"
		mainNumberLabel.text = ("+" if speedValue > 0 else "") + "%.2f" % speedValue
		trait_vbox.add_child(mainLabel)
		number_vbox.add_child(mainNumberLabel)
		var spaceLabel = Label.new()
		var spaceNumLabel = Label.new()
		trait_vbox.add_child(spaceLabel)
		number_vbox.add_child(spaceNumLabel)

	if len(fuelArray) > 0:
		for value in fuelArray:
			fuelValue += value.values()[0]

		var mainLabel = Label.new()
		var mainNumberLabel = Label.new()
		mainLabel.label_settings = preload("res://Data/Resources/LabelSettings.tres")
		mainNumberLabel.label_settings = preload("res://Data/Resources/LabelSettings.tres")
		mainLabel.text = "FUEL"
		mainNumberLabel.text = ("+" if fuelValue > 0 else "") + "%.2f" % fuelValue
		trait_vbox.add_child(mainLabel)
		number_vbox.add_child(mainNumberLabel)
	#partName.text = str(part.rocketModifier.modifierName) + " " + str(part.rocketPart.upgradeName) if part.rocketModifier != null else str(part.rocketPart.upgradeName)
	
	button.icon = part.rocketPart.partSprite
	button.set("theme_override_colors/icon_normal_color", part.rocketPart.modulate)
	button.set("theme_override_colors/icon_hover_color", part.rocketPart.modulate)
	button.set("theme_override_colors/icon_hover_pressed_color", part.rocketPart.modulate)
	button.set("theme_override_colors/icon_disabled_color", part.rocketPart.modulate)
	button.set("theme_override_colors/icon_pressed_color", part.rocketPart.modulate)

	partValue.push_front(fuelValue)
	partValue.push_front(speedValue)

	#button.self_modulate = rocket.modulate

func _on_AssemblyButton1_pressed():
	_disableButtons()
	$Select.play()
	Constants._addPart(part1, part1Value)
	#Constants.rocketNoseModulate = rocketNose2.modulate
	Constants.transitioning = true
	animation.play("TransitionOut")
	await animation.animation_finished
	_tree_check()

func _on_AssemblyButton2_pressed():
	_disableButtons()
	$Select.play()
	Constants._addPart(part2, part2Value)
	#Constants.rocketNoseModulate = rocketNose2.modulate
	Constants.transitioning = true
	animation.play("TransitionOut")
	await animation.animation_finished
	_tree_check()

func _on_AssemblyButton3_pressed():
	_disableButtons()
	$Select.play()
	Constants._addPart(part3, part3Value)
	#Constants.rocketNoseModulate = rocketNose2.modulate
	Constants.transitioning = true
	animation.play("TransitionOut")
	await animation.animation_finished
	_tree_check()

func _disableButtons():
	$AssemblyButton1.disabled = true
	$AssemblyButton2.disabled = true
	$AssemblyButton3.disabled = true

func _tree_check():
	_stage_finished()

func _on_timer_timeout() -> void:
	_on_AssemblyButton2_pressed()


func _stage_finished():
	if Constants.stage == "NOSE":
		_nose_finished()
	elif Constants.stage == "BODY":
		_body_finished()
	elif Constants.stage == "BOTTOM":
		_bottom_finished()

func _nose_finished():
	Constants.stage = "BODY"
	get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")

func _body_finished():
	Constants.stage = "BOTTOM"
	get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")

func _bottom_finished():
	Constants.stage = "NOSE"
	get_tree().change_scene_to_file("res://Common/World/Scenes/World.tscn")


func _on_button_toggled(toggled_on:bool) -> void:
	if toggled_on:
		Constants.endlessModeEnabled = true
		$EndlessButton.modulate = '00ff00'
		$EndlessSelect.play()
	else:
		Constants.endlessModeEnabled = false
		$EndlessButton.modulate = 'ff0000'
		$EndlessSelect.play()
