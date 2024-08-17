extends Control

func _ready() -> void:
	SC.open_build.connect(handle_open_build)


func handle_open_build(item_type: String, node: Node2D) -> void:
	if item_type == "landing_pad":
		pass
