extends Node2D

onready var altitude = $Altitude/AltitudeValue

onready var animation = $AssemblyAnimationSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	altitude.text = str(Constants.highestAltitude) + "ft"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if Constants.tutorial:
			animation.play("TransitionOut")
			yield(animation, "animation_finished")
			get_tree().change_scene("res://Scenes/Tutorial.tscn")
		animation.play("TransitionOut")
		yield(animation, "animation_finished")
		get_tree().change_scene("res://Scenes/AssemblyNose.tscn")
