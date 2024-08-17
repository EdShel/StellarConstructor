extends BasePopup
class_name PistonPopup

func _ready() -> void:
	for dir in %Directions.get_children():
		dir.gui_input.connect(func(event: InputEvent) -> void:
			handle_dir_click(dir, event)
		)

func handle_dir_click(source: Node, event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		closed.emit({
			"direction": source.name,
		})
