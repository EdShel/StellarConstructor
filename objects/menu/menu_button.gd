extends Label

signal clicked()

@export var hover_color: Color

func _on_mouse_entered() -> void:
	self_modulate = hover_color
	%SelectedSound.play()
	

func _on_mouse_exited() -> void:
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		%ConfirmSound.play()
		clicked.emit()
