extends Camera2D

@export var is_drag_allowed = true

var zoom_sensitivity = 0.1
var pan_sensitivity = 1.0

var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2()
var camera_drag_start_position: Vector2 = Vector2()

var zoom_min: float = 0.05
var zoom_max: float = 2.0

var move_speed: float = 300

func _unhandled_input(event: InputEvent) -> void:
	if !is_drag_allowed:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			#get_viewport().set_input_as_handled()
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
			if is_dragging:
				var delta = event.position - drag_start_position
				position = camera_drag_start_position - delta / zoom.x
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var new_zoom = clamp(zoom.x - zoom_sensitivity, zoom_min, zoom_max)
			zoom = Vector2(new_zoom, new_zoom)
			if is_dragging:
				var delta = event.position - drag_start_position
				position = camera_drag_start_position - delta / zoom.x
			get_viewport().set_input_as_handled()

	elif event is InputEventMouseMotion and is_dragging:
		var delta = event.position - drag_start_position
		position = camera_drag_start_position - delta / zoom.x
		get_viewport().set_input_as_handled()
