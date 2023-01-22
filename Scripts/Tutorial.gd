extends Node2D


onready var animation = $AssemblyAnimationSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	Constants.tutorial = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		animation.play("TransitionOut")
		yield(animation, "animation_finished")
		get_tree().change_scene("res://Scenes/AssemblyNose.tscn")
