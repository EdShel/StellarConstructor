extends PanelContainer
class_name BasePopup

signal closed(result: Dictionary)

var is_closing: bool = false

func _enter_tree() -> void:
	SC.enable_no_tooltip_mode.emit(true)
	
func _exit_tree() -> void:
	SC.enable_no_tooltip_mode.emit(false)
	
func _on_cancel_button_pressed() -> void:
	is_closing = true
	closed.emit({})

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			closed.emit({})
			get_viewport().set_input_as_handled()


func _on_close_icon_mouse_entered() -> void:
	if is_closing or not %CloseIcon:
		return
	var tween = create_tween()
	tween.tween_property(%CloseIcon, "modulate", Color(0.7, 0.7, 0.7, 1.0), 0.2)


func _on_close_icon_mouse_exited() -> void:
	if is_closing or not %CloseIcon:
		return
	var tween = create_tween()
	tween.tween_property(%CloseIcon, "modulate", Color.WHITE, 0.2)


func _on_close_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_closing = true
		closed.emit({})
		get_viewport().set_input_as_handled()
