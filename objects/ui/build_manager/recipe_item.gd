extends Control
class_name ToolbarItem

signal clicked(node: ToolbarItem)

@export var recipe_name: String:
	get: return %Label.text
	set(value): %Label.text = value
@export var icon: Texture2D:
	get: return %Icon.texture
	set(value): %Icon.texture = value
@export var item_type: String = "ore"
@export var item_count: int = 10

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		clicked.emit(self)
