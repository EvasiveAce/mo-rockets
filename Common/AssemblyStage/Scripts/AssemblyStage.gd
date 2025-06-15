extends Node2D

@onready var assemblySprite = load("res://Common/AssemblyStage/Sprites/AssemblyScreen.png")
@onready var assemblySpriteNoUpgrade = load("res://Common/AssemblyStage/Sprites/AssemblyScreenDefault.png")

@onready var partObject
@onready var text = $AssemblyLabel
@onready var animation = $AssemblyAnimationSprite

@onready var button1 = $AssemblyButton1
@onready var trait1 = $AssemblyButton1/AssemblyNameBox/AssemblyTrait1
@onready var trait1_2 = $AssemblyButton1/AssemblyNameBox/AssemblyTrait2
@onready var stats1 = $AssemblyButton1/AssemblyStatsBox/AssemblyStats1
@onready var stats1_2 = $AssemblyButton1/AssemblyStatsBox/AssemblyStats2

@onready var button2 = $AssemblyButton2
@onready var trait2 = $AssemblyButton2/AssemblyNameBox/AssemblyTrait1
@onready var trait2_2 = $AssemblyButton2/AssemblyNameBox/AssemblyTrait2
@onready var stats2 = $AssemblyButton2/AssemblyStatsBox/AssemblyStats1
@onready var stats2_2 = $AssemblyButton2/AssemblyStatsBox/AssemblyStats2
@onready var partName = $AssemblyButton2/Name

@onready var button3 = $AssemblyButton3
@onready var trait3 = $AssemblyButton3/AssemblyNameBox/AssemblyTrait1
@onready var trait3_2 = $AssemblyButton3/AssemblyNameBox/AssemblyTrait2
@onready var stats3 = $AssemblyButton3/AssemblyStatsBox/AssemblyStats1
@onready var stats3_2 = $AssemblyButton3/AssemblyStatsBox/AssemblyStats2

var part1
var part2
var part3

# Called when the node enters the scene tree for the first time.
func _ready():
	_checkStage()
	if Constants.partChoiceUpgrade:
		$AssemblySprite.texture = assemblySprite
		$AssemblyButton1.visible = true
		$AssemblyButton3.visible = true
	else:
		$AssemblySprite.texture = assemblySpriteNoUpgrade
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


	#_fillOutButton(button1, trait1, trait1_2, stats1, stats1_2, rocketNose1)
	_fillOutButton(button2, part2)
	#_fillOutButton(button3, trait3, trait3_2, stats3, stats3_2, rocketNose3)

func _checkStage():
	if Constants.stage == "NOSE":
		partObject = load("res://Common/World/RocketObject/Scenes/RocketNose.tscn")
	elif Constants.stage == "BODY":
		partObject = load("res://Common/World/RocketObject/Scenes/RocketBody.tscn")
	elif Constants.stage == "BOTTOM":
		partObject = load("res://Common/World/RocketObject/Scenes/RocketBottom.tscn")


func _process(_delta: float) -> void:
	if Constants.automation1 && $Timer.is_stopped():
		$Timer.start(2.5)

func _clear_container(container : VBoxContainer) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

func _fillOutButton(button : Button, part):
	var speedArray = []
	var fuelArray = []
	var speedValue : float = 0.0
	var fuelValue : float = 0.0
	var speedStat = RocketPart.StatType.keys()[1]
	var fuelStat = RocketPart.StatType.keys()[2]

	var trait_vbox = button.get_node("AssemblyNameBox")
	var number_vbox = button.get_node("AssemblyStatsBox")
	
	_clear_container(trait_vbox)
	_clear_container(number_vbox)

	if part.rocketPart.StatType.keys()[part.rocketPart.statModifier1Name] != part.rocketPart.StatType.keys()[part.rocketPart.StatType.NONE]:
		match part.rocketPart.StatType.keys()[part.rocketPart.statModifier1Name]:
			speedStat:
				speedArray.push_front({"Part" : part.rocketPart.statModifier1Amount})
			fuelStat:
				fuelArray.push_front({"Part" : part.rocketPart.statModifier1Amount})

	if part.rocketPart.StatType.keys()[part.rocketPart.statModifier2Name] != part.rocketPart.StatType.keys()[part.rocketPart.StatType.NONE]:
		match part.rocketPart.StatType.keys()[part.rocketPart.statModifier2Name]:
			speedStat:
				speedArray.push_front({"Part" : part.rocketPart.statModifier2Amount})
			fuelStat:
				fuelArray.push_front({"Part" : part.rocketPart.statModifier2Amount})

	if len(Constants.modifiers) > 0 and part.rocketModifier != null:
		if part.rocketModifier.StatType.keys()[part.rocketModifier.statModifier1Name] != part.rocketModifier.StatType.keys()[part.rocketModifier.StatType.NONE]:
			match part.rocketModifier.StatType.keys()[part.rocketModifier.statModifier1Name]:
				speedStat:
					speedArray.push_front({part.rocketModifier.modifierName : part.rocketModifier.statModifier1Amount})
				fuelStat:
					fuelArray.push_front({part.rocketModifier.modifierName : part.rocketModifier.statModifier1Amount})
		
		if part.rocketModifier.StatType.keys()[part.rocketModifier.statModifier2Name] != part.rocketModifier.StatType.keys()[part.rocketModifier.StatType.NONE]:
			match part.rocketModifier.StatType.keys()[part.rocketModifier.statModifier2Name]:
				speedStat:
					speedArray.push_front({part.rocketModifier.modifierName : part.rocketModifier.statModifier2Amount})
				fuelStat:
					fuelArray.push_front({part.rocketModifier.modifierName : part.rocketModifier.statModifier2Amount})
	
	if len(speedArray) > 0:
		for value in speedArray:
			speedValue += value.values()[0]

		var mainLabel = Label.new()
		var mainNumberLabel = Label.new()
		mainLabel.label_settings = preload("res://Data/Resources/LabelSettings.tres")
		mainNumberLabel.label_settings = preload("res://Data/Resources/LabelSettings.tres")
		mainLabel.text = "SPEED"
		mainNumberLabel.text = "+" + str(speedValue) if speedValue > 0 else str(speedValue)
		trait_vbox.add_child(mainLabel)
		number_vbox.add_child(mainNumberLabel)
		for pair in speedArray:
			var label = Label.new()
			var numbLabel = Label.new()
			label.label_settings = preload("res://Data/Resources/LabelSettings.tres")
			numbLabel.label_settings = preload("res://Data/Resources/LabelSettings.tres")
			label.text = "  |_ " + pair.keys()[0]
			numbLabel.text = "+" + str(pair.values()[0]) if pair.values()[0] > 0 else str(pair.values()[0])
			trait_vbox.add_child(label)
			number_vbox.add_child(numbLabel)
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
		mainNumberLabel.text = "+" + str(fuelValue) if fuelValue > 0 else str(fuelValue)
		trait_vbox.add_child(mainLabel)
		number_vbox.add_child(mainNumberLabel)
		for pair in fuelArray:
			var label = Label.new()
			var numbLabel = Label.new()
			label.label_settings = preload("res://Data/Resources/LabelSettings.tres")
			numbLabel.label_settings = preload("res://Data/Resources/LabelSettings.tres")
			label.text = "  |_ " + pair.keys()[0]
			numbLabel.text = "+" + str(pair.values()[0]) if pair.values()[0] > 0 else str(pair.values()[0])
			trait_vbox.add_child(label)
			number_vbox.add_child(numbLabel)

	partName.text = str(part.rocketModifier.modifierName) + " " + str(part.rocketPart.upgradeName) if part.rocketModifier != null else str(part.rocketPart.upgradeName)
	
	button.icon = part.rocketPart.partSprite
	#button.self_modulate = rocket.modulate

func _on_AssemblyButton1_pressed():
	$Select.play()
	animation.play("TransitionOut")
	await animation.animation_finished
	_tree_check()

func _on_AssemblyButton2_pressed():
	$Select.play()
	Constants._addPart(part2)
	#Constants.rocketNoseModulate = rocketNose2.modulate
	animation.play("TransitionOut")
	await animation.animation_finished
	_tree_check()

func _on_AssemblyButton3_pressed():
	$Select.play()
	animation.play("TransitionOut")
	await animation.animation_finished
	_tree_check()

func _tree_check():
	if not is_inside_tree():
		return
	else:
		SignalBus.stage_finished.emit()

func _on_timer_timeout() -> void:
	_on_AssemblyButton2_pressed()
