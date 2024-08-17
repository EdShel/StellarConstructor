extends Control

func _ready() -> void:
	SC.open_build.connect(handle_open_build)


func handle_open_build(item_type: String, node: Node2D) -> void:
	if item_type == "landing_pad":
		var popup = preload("res://objects/ui/build_manager/launch_pad_recipe_popup.tscn").instantiate()
		popup.connect("closed", func(recipe: Dictionary) -> void: 
			popup.queue_free()
			node.recipe = recipe
		)
		%PopupContainer.add_child(popup)
		pass
