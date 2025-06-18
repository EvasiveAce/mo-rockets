extends ParallaxBackground
var scroll_speed = 1.0

func _ready():
	scroll_ignore_camera_zoom = true
	follow_viewport_enabled = true

func _process(delta):
	scroll_base_offset.x += scroll_speed * delta
	scroll_offset.y = 0
