extends Node2D

@onready var camera = $Camera2D

var inside_container: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



var pivot_camera=Vector2.ZERO

var zoomspeed = 500
var zoommargin = 0.1

@export var min_zoom := 0.5
@export var max_zoom := 2.0

var zoompos = Vector2()
var zoomfactor = 1.0

func _physics_process(_delta):
	if not inside_container:
		return


	if Input.is_action_just_pressed("grab_camera"):
		pivot_camera=get_global_mouse_position()
	if Input.is_action_pressed("grab_camera"):
		var gap=pivot_camera-get_global_mouse_position()
		camera.offset+=gap


func _input(event: InputEvent) -> void:
	if abs(zoompos.x - get_global_mouse_position().x) > zoommargin:
		zoomfactor = 1.0
	if abs(zoompos.y - get_global_mouse_position().y) > zoommargin:
		zoomfactor = 1.0

	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoomfactor -= 0.01
				zoompos = get_global_mouse_position()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoomfactor += 0.01
				zoompos = get_global_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.zoom.x = lerp($Camera2D.zoom.x, $Camera2D.zoom.x * zoomfactor, zoomspeed * delta) 
	$Camera2D.zoom.y = lerp($Camera2D.zoom.y, $Camera2D.zoom.y * zoomfactor, zoomspeed * delta) 

	$Camera2D.zoom.x = clamp($Camera2D.zoom.x, min_zoom, max_zoom)
	$Camera2D.zoom.y = clamp($Camera2D.zoom.y, min_zoom, max_zoom)


func _on_shop_viewport_mouse_entered() -> void:
	inside_container = true


func _on_shop_viewport_mouse_exited() -> void:
	inside_container = false
