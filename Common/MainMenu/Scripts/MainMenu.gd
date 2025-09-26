extends Node2D

@onready var altitude = $Altitude/AltitudeValue
@onready var animation = $AssemblyAnimationSprite

var rocket
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(0, linear_to_db(50.0/100.0))
	animation.flip_v = true
	animation.play("TransitionIn")
	animation.flip_v = false
	altitude.text = str(Constants.highestAltitude) + "m"
	await animation.animation_finished
	Constants.transitioning = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		Constants.transitioning = true
		if Constants.tutorial:
			animation.play("TransitionOut")
			await animation.animation_finished
			get_tree().change_scene_to_file("res://Common/Tutorial/Scenes/Tutorial.tscn")
		animation.play("TransitionOut")
		await animation.animation_finished
		get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn") 
