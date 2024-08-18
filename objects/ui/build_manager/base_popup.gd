extends PanelContainer
class_name BasePopup

signal closed(result: Dictionary)

func _enter_tree() -> void:
	SC.enable_no_tooltip_mode.emit(true)
	
func _exit_tree() -> void:
	SC.enable_no_tooltip_mode.emit(false)
	
func _on_cancel_button_pressed() -> void:
	closed.emit({})

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			closed.emit({})
			get_viewport().set_input_as_handled()
