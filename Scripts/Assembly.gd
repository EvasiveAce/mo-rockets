extends Node2D

onready var rocketNoseObject = load("res://Scenes/RocketNose.tscn")
onready var text = $AssemblyLabel

onready var animation = $AssemblyAnimationSprite

onready var button1 = $AssemblyButton1
onready var trait1 = $AssemblyButton1/AssemblyNameBox/AssemblyTrait1
onready var trait1_2 = $AssemblyButton1/AssemblyNameBox/AssemblyTrait2
onready var stats1 = $AssemblyButton1/AssemblyStatsBox/AssemblyStats1
onready var stats1_2 = $AssemblyButton1/AssemblyStatsBox/AssemblyStats2

onready var button2 = $AssemblyButton2
onready var trait2 = $AssemblyButton2/AssemblyNameBox/AssemblyTrait1
onready var trait2_2 = $AssemblyButton2/AssemblyNameBox/AssemblyTrait2
onready var stats2 = $AssemblyButton2/AssemblyStatsBox/AssemblyStats1
onready var stats2_2 = $AssemblyButton2/AssemblyStatsBox/AssemblyStats2

onready var button3 = $AssemblyButton3
onready var trait3 = $AssemblyButton3/AssemblyNameBox/AssemblyTrait1
onready var trait3_2 = $AssemblyButton3/AssemblyNameBox/AssemblyTrait2
onready var stats3 = $AssemblyButton3/AssemblyStatsBox/AssemblyStats1
onready var stats3_2 = $AssemblyButton3/AssemblyStatsBox/AssemblyStats2

var rocketNose1
var rocketNose2
var rocketNose3

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	Constants.stage = "NOSE"
	text.text = "CHOOSE A " + Constants.stage
	rocketNose1 = rocketNoseObject.instance()
	rocketNose2 = rocketNoseObject.instance()
	rocketNose3 = rocketNoseObject.instance()
	add_child(rocketNose1)
	add_child(rocketNose2)
	add_child(rocketNose3)


	_fillOutButton(button1, trait1, trait1_2, stats1, stats1_2, rocketNose1)
	_fillOutButton(button2, trait2, trait2_2, stats2, stats2_2, rocketNose2)
	_fillOutButton(button3, trait3, trait3_2, stats3, stats3_2, rocketNose3)


func _fillOutButton(button, trait1, trait2, stats1, stats2, rocket):
	trait1.text = rocket.nameString
	trait2.text = rocket.nameString2
	stats1.text = str("%.2f" % rocket.statFloat)
	stats2.text = str("%.2f" % rocket.statFloat2)
	
	button.icon = rocket.spriteTexture
	button.self_modulate = rocket.modulate


func _on_AssemblyButton1_pressed():
	$Select.play()
	Constants.rocketNose = rocketNose1.spriteTexture
	Constants.rocketNoseModulate = rocketNose1.modulate
	Constants._determineTrait(rocketNose1.nameString, rocketNose1.statFloat)
	Constants._determineTrait(rocketNose1.nameString2, rocketNose1.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/AssemblyBody.tscn")


func _on_AssemblyButton2_pressed():
	$Select.play()
	Constants.rocketNose = rocketNose2.spriteTexture
	Constants.rocketNoseModulate = rocketNose2.modulate
	Constants._determineTrait(rocketNose2.nameString, rocketNose2.statFloat)
	Constants._determineTrait(rocketNose2.nameString2, rocketNose2.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/AssemblyBody.tscn")

func _on_AssemblyButton3_pressed():
	$Select.play()
	Constants.rocketNose = rocketNose3.spriteTexture
	Constants.rocketNoseModulate = rocketNose3.modulate
	Constants._determineTrait(rocketNose3.nameString, rocketNose3.statFloat)
	Constants._determineTrait(rocketNose3.nameString2, rocketNose3.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/AssemblyBody.tscn")
