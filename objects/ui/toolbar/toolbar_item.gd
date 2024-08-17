extends Control

var _count: int = 0

func set_count(value: int) -> void:
	%CountLabel.text = str(value)
	_count = value
	
func get_count() -> int:
	return _count


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if _count > 0:
			SC.toolbar_item_pressed.emit(name)
