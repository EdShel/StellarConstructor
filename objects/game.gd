extends Node2D

var _ghost_node: Node2D = null
var _ghost_node_item: String = ""

var inventory: Array[Dictionary] = [
	{
		"item": "solar",
		"count": 5,
	},
	{
		"item": "piston",
		"count": 5,
	},
	{
		"item": "factory",
		"count": 1,
	},
	{
		"item": "landing_pad",
		"count": 3,
	},
]

var power_goal = 50
var power_production = 0
var power_consumption = 0

func _enter_tree() -> void:
	SC.connect("toolbar_item_pressed", handle_toolbar_item_pressed)
	SC.connect("toolbar_item_place", handle_toolbar_item_place)
	
	SC.connect("increase_power_production", handle_power_production_increase)
	SC.connect("increase_power_consumption", handle_power_consumption_increase)
	
	SC.connect("increase_inventory_item", handle_increase_inventory_item)
	
	SC.set_game(self)

func _ready() -> void:
	%Toolbar.init_inventory(inventory)

func _exit_tree() -> void:
	SC.set_game(null)
	return # TODO: unsubscribe

func _process(delta: float) -> void:
	pass

func handle_toolbar_item_pressed(item_type: String) -> void:
	if _ghost_node_item == item_type:
		clear_ghost()
		return
	
	var inventory_item = find_inventory_item(item_type)
	if inventory_item["count"] <= 0:
		return
	
	if !_ghost_node:
		_ghost_node = load("res://objects/build_grid/ghost.tscn").instantiate()
		%BuildGrid.add_child(_ghost_node)
	
	var sprite: AtlasTexture = load("res://sprites/builds/%s.tres" % item_type)
	_ghost_node.update(sprite)
	_ghost_node_item = item_type
	
	%Camera2D.is_drag_allowed = false

func handle_toolbar_item_place(at: Vector2) -> void:
	var inventory_item = find_inventory_item(_ghost_node_item)
	if !inventory_item:
		printerr("Placing without active ghost")
		return
	
	var building: Node2D = load("res://objects/builds/%s.tscn" % _ghost_node_item).instantiate()
	%BuildGrid.add_child(building)
	building.global_position = at
	
	inventory_item["count"] -= 1
	%Toolbar.init_inventory(inventory)
	if inventory_item["count"] <= 0:
		clear_ghost()

func clear_ghost():
	if !_ghost_node:
		return
	_ghost_node.queue_free()
	_ghost_node = null
	_ghost_node_item = ""
	%Camera2D.is_drag_allowed = true

func find_inventory_item(item: String) -> Dictionary:
	return inventory.filter(func(i: Dictionary): return i["item"] == item).front()

func handle_power_production_increase(amount: int) -> void:
	power_production += amount
	SC.power_stats_changed.emit()

func handle_power_consumption_increase(amount: int) -> void:
	power_consumption += amount
	SC.power_stats_changed.emit()

func handle_increase_inventory_item(item_type: String, amount: int) -> void:
	var item = find_inventory_item(item_type)
	item["count"] += amount
	%Toolbar.init_inventory(inventory)
