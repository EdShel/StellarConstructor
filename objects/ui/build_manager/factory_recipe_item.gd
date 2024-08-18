extends TextureRect

signal clicked()
signal hover_changed(is_hovered: bool)

var item_type: String = "ore"

func _ready() -> void:
	texture = ItemHelper.get_item_icon(item_type)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit()


func _on_mouse_entered() -> void:
	hover_changed.emit(true)


func _on_mouse_exited() -> void:
	hover_changed.emit(false)
