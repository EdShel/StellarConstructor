extends Control

var _count: int = 0

func set_count(value: int) -> void:
	%CountLabel.text = str(value)
	_count = value
	
func get_count() -> int:
	return _count


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		SC.toolbar_item_pressed.emit(name)
		accept_event()


func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(%Background, "scale", Vector2(1.2, 1.2), 0.1)


func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(%Background, "scale", Vector2(1, 1), 0.1)
