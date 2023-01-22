extends Node2D

onready var rocketBodyObject = load("res://Scenes/RocketBody.tscn")
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

var rocketBody1
var rocketBody2
var rocketBody3

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	Constants.stage = "BODY"
	text.text = "CHOOSE A " + Constants.stage
	rocketBody1 = rocketBodyObject.instance()
	rocketBody2 = rocketBodyObject.instance()
	rocketBody3 = rocketBodyObject.instance()
	add_child(rocketBody1)
	add_child(rocketBody2)
	add_child(rocketBody3)


	_fillOutButton(button1, trait1, trait1_2, stats1, stats1_2, rocketBody1)
	_fillOutButton(button2, trait2, trait2_2, stats2, stats2_2, rocketBody2)
	_fillOutButton(button3, trait3, trait3_2, stats3, stats3_2, rocketBody3)


func _fillOutButton(button, trait1, trait2, stats1, stats2, rocket):
	trait1.text = rocket.nameString
	trait2.text = rocket.nameString2
	stats1.text = str("%.2f" % rocket.statFloat)
	stats2.text = str("%.2f" % rocket.statFloat2)
	
	button.icon = rocket.spriteTexture
	button.self_modulate = rocket.modulate


func _on_AssemblyButton1_pressed():
	$Select.play()
	Constants.rocketBody = rocketBody1.spriteTexture
	Constants.rocketBodyModulate = rocketBody1.modulate
	Constants._determineTrait(rocketBody1.nameString, rocketBody1.statFloat)
	Constants._determineTrait(rocketBody1.nameString2, rocketBody1.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/AssemblyBottom.tscn")


func _on_AssemblyButton2_pressed():
	$Select.play()
	Constants.rocketBody = rocketBody2.spriteTexture
	Constants.rocketBodyModulate = rocketBody2.modulate
	Constants._determineTrait(rocketBody2.nameString, rocketBody2.statFloat)
	Constants._determineTrait(rocketBody2.nameString2, rocketBody2.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/AssemblyBottom.tscn")

func _on_AssemblyButton3_pressed():
	$Select.play()
	Constants.rocketBody = rocketBody3.spriteTexture
	Constants.rocketBodyModulate = rocketBody3.modulate
	Constants._determineTrait(rocketBody3.nameString, rocketBody3.statFloat)
	Constants._determineTrait(rocketBody3.nameString2, rocketBody3.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/AssemblyBottom.tscn")
