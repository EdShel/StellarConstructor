extends Area2D

@export var cell_size: int = 1
@export var item_type: String = "solar"

func _ready() -> void:
	var bbox = RectangleShape2D.new()
	bbox.size = Vector2(cell_size * 64, cell_size * 64)
	%CollisionShape2D.shape = bbox

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		get_parent().queue_free()
		SC.increase_inventory_item.emit(item_type, 1)
		SC.recompute_space_platform_size.emit()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		SC.open_build.emit(item_type, get_parent())


func _on_mouse_entered() -> void:
	SC.show_build_tooltip.emit(item_type, get_parent())


func _on_mouse_exited() -> void:
	SC.hide_build_tooltip.emit(item_type, get_parent())
