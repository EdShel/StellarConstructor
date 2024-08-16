extends Node2D

var _ghost_node: Node = null
var ghost_node_size: int = 1

func _ready() -> void:
	SC.connect("toolbelt_item_pressed", handle_toolbelt_item_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_toolbelt_item_pressed(item_type: String):
	if !_ghost_node:
		_ghost_node = Sprite2D.new()
	
		
	
	pass
