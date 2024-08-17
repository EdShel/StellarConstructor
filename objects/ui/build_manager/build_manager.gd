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
		return
	if item_type == "piston":
		var popup = preload("res://objects/ui/build_manager/piston_popup.tscn").instantiate()
		popup.connect("closed", func(data: Dictionary) -> void: 
			popup.queue_free()
			if data.is_empty():
				return
			var direction = data["direction"]
			if direction == "right":
				node.direction = Piston.Direction.RIGHT
				return
			if direction == "left":
				node.direction = Piston.Direction.LEFT
				return
			if direction == "up":
				node.direction = Piston.Direction.UP
				return
			if direction == "down":
				node.direction = Piston.Direction.DOWN
				return
		)
		%PopupContainer.add_child(popup)
		
		return
