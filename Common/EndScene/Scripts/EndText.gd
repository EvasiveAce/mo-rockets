extends Node2D


@onready var animation = $AssemblyAnimationSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	Constants.endText = false
	await animation.animation_finished
	Constants.transitioning = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		Constants.transitioning = true
		animation.play("TransitionOut")
		await animation.animation_finished
		get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")
