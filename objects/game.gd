extends Node2D

var _ghost_node: Node = null
var ghost_node_size: int = 1

func _ready() -> void:
	SC.connect("toolbar_item_pressed", handle_toolbar_item_pressed)

func _process(delta: float) -> void:
	pass

func handle_toolbar_item_pressed(item_type: String):
	if !_ghost_node:
		_ghost_node = preload("res://objects/build_grid/ghost.tscn").instantiate()
		%BuildGrid.add_child(_ghost_node)
	
	var sprite: AtlasTexture = load("res://sprites/builds/%s.tres" % item_type)
	_ghost_node.update(sprite)
	
	pass
