extends Camera2D

@export var is_drag_allowed = true

var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2()
var camera_drag_start_position: Vector2 = Vector2()

var move_speed: float = 800

var zoom_levels: Array[float] = [0.25, 0.5, 0.75, 1, 1.5, 2, 2.5, 3]
var zoom_level_index = 3

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if is_drag_allowed:
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
			zoom_level_index = clamp(zoom_level_index + 1, 0, zoom_levels.size() - 1)
			update_zoom(zoom_levels[zoom_level_index], event)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_level_index = clamp(zoom_level_index - 1, 0, zoom_levels.size() - 1)
			update_zoom(zoom_levels[zoom_level_index], event)
			get_viewport().set_input_as_handled()

	elif is_drag_allowed and event is InputEventMouseMotion and is_dragging:
		var delta = event.position - drag_start_position
		position = camera_drag_start_position - delta / zoom.x
		get_viewport().set_input_as_handled()
		

func update_zoom(new_zoom: float, event: InputEventMouseButton) -> void:
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(new_zoom, new_zoom), 0.2)
	is_dragging = false
		
		#var delta = event.position - drag_start_position
		#position = camera_drag_start_position - delta / zoom.x
		#tween.tween_property(self, "position", camera_drag_start_position - delta / zoom.x, 0.2)
	
	var zoom_range = zoom_levels.back() - zoom_levels.front()
	var volume = new_zoom / zoom_range
	var sfx = AudioServer.get_bus_index("SFX_Env")
	AudioServer.set_bus_volume_db(sfx, linear_to_db(volume))

func _process(delta: float) -> void:
	var move_dir = Input.get_vector("left", "right", "up", "down")
	if move_dir != Vector2.ZERO:
		global_position += move_dir * delta * move_speed / zoom
