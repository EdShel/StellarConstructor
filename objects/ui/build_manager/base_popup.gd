extends PanelContainer
class_name BasePopup

signal closed(result: Dictionary)

func _on_cancel_button_pressed() -> void:
	closed.emit({})

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			closed.emit({})
			accept_event()
