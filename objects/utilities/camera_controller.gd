extends Camera2D


var zoom_sensitivity = 0.1
var pan_sensitivity = 1.0

var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2()
var camera_drag_start_position: Vector2 = Vector2()

var zoom_min: float = 0.05
var zoom_max: float = 2.0

var move_speed: float = 300

func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if !is_dragging:
					is_dragging = true
					drag_start_position = event.position
					camera_drag_start_position = position
			else:
				is_dragging = false
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var new_zoom = clamp(zoom.x + zoom_sensitivity, zoom_min, zoom_max)
			zoom = Vector2(new_zoom, new_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var new_zoom = clamp(zoom.x - zoom_sensitivity, zoom_min, zoom_max)
			zoom = Vector2(new_zoom, new_zoom)

	elif event is InputEventMouseMotion and is_dragging:
		var delta = event.position - drag_start_position
		position = camera_drag_start_position - delta / zoom.x



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
