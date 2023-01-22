extends Node2D

onready var RocketBottomObject = load("res://Scenes/RocketBottom.tscn")
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

var RocketBottom1
var RocketBottom2
var RocketBottom3

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	Constants.stage = "BOTTOM"
	text.text = "CHOOSE A " + Constants.stage
	RocketBottom1 = RocketBottomObject.instance()
	RocketBottom2 = RocketBottomObject.instance()
	RocketBottom3 = RocketBottomObject.instance()
	add_child(RocketBottom1)
	add_child(RocketBottom2)
	add_child(RocketBottom3)


	_fillOutButton(button1, trait1, trait1_2, stats1, stats1_2, RocketBottom1)
	_fillOutButton(button2, trait2, trait2_2, stats2, stats2_2, RocketBottom2)
	_fillOutButton(button3, trait3, trait3_2, stats3, stats3_2, RocketBottom3)


func _fillOutButton(button, trait1, trait2, stats1, stats2, rocket):
	trait1.text = rocket.nameString
	trait2.text = rocket.nameString2
	stats1.text = str("%.2f" % rocket.statFloat)
	stats2.text = str("%.2f" % rocket.statFloat2)
	
	button.icon = rocket.spriteTexture
	button.self_modulate = rocket.modulate


func _on_AssemblyButton1_pressed():
	$Select.play()
	Constants.rocketBottom = RocketBottom1.spriteTexture
	Constants.rocketBottomModulate = RocketBottom1.modulate
	Constants._determineTrait(RocketBottom1.nameString, RocketBottom1.statFloat)
	Constants._determineTrait(RocketBottom1.nameString2, RocketBottom1.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_AssemblyButton2_pressed():
	$Select.play()
	Constants.rocketBottom = RocketBottom2.spriteTexture
	Constants.rocketBottomModulate = RocketBottom2.modulate
	Constants._determineTrait(RocketBottom2.nameString, RocketBottom2.statFloat)
	Constants._determineTrait(RocketBottom2.nameString2, RocketBottom2.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/World.tscn")

func _on_AssemblyButton3_pressed():
	$Select.play()
	Constants.rocketBottom = RocketBottom3.spriteTexture
	Constants.rocketBottomModulate = RocketBottom3.modulate
	Constants._determineTrait(RocketBottom3.nameString, RocketBottom3.statFloat)
	Constants._determineTrait(RocketBottom3.nameString2, RocketBottom3.statFloat2)
	animation.play("TransitionOut")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://Scenes/World.tscn")
