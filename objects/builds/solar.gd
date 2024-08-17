extends Node2D

@export var power_production = 5

func _ready() -> void:
	SC.increase_power_production.emit(power_production)

func _exit_tree() -> void:
	SC.increase_power_production.emit(-power_production)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		queue_free()
		SC.increase_inventory_item.emit("solar", 1)
