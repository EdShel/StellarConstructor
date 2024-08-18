extends Node2D
class_name Game

var _ghost_node: Node2D = null
var _ghost_node_item: String = ""

var inventory: Inventory = Inventory.new([
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
])

var power_goal = 50
var power_production = 0
var power_consumption = 0

var ore_miner: ResourceMiner
var crystal_miner: ResourceMiner
var water_miner: ResourceMiner

func _enter_tree() -> void:
	SC.connect("toolbar_item_pressed", handle_toolbar_item_pressed)
	SC.connect("toolbar_item_place", handle_toolbar_item_place)
	SC.connect("toolbar_item_dismiss", clear_ghost)
	
	SC.connect("increase_power_production", handle_power_production_increase)
	SC.connect("increase_power_consumption", handle_power_consumption_increase)
	
	SC.connect("increase_inventory_item", handle_increase_inventory_item)
	SC.connect("increase_mining_speed", handle_increase_mining_speed)
	
	ore_miner = ResourceMiner.new("ore")
	crystal_miner = ResourceMiner.new("crystal")
	water_miner = ResourceMiner.new("water")
	
	SC.set_game(self)

func _ready() -> void:
	%Toolbar.init_inventory(inventory.items)

func _exit_tree() -> void:
	SC.set_game(null)
	return # TODO: unsubscribe

func _process(delta: float) -> void:
	ore_miner.process(delta)
	crystal_miner.process(delta)
	water_miner.process(delta)

func handle_toolbar_item_pressed(item_type: String) -> void:
	if _ghost_node_item == item_type:
		clear_ghost()
		return
	
	var inventory_item = inventory.get_inventory_item(item_type)
	if inventory_item["count"] <= 0:
		return
	
	if !_ghost_node:
		_ghost_node = load("res://objects/build_grid/ghost.tscn").instantiate()
		%BuildGrid.add_child(_ghost_node)
	
	_ghost_node.update(item_type)
	_ghost_node_item = item_type
	
	%Camera2D.is_drag_allowed = false
	SC.enable_no_tooltip_mode.emit(true)

func handle_toolbar_item_place(data: Dictionary) -> void:
	var inventory_item = inventory.get_inventory_item(_ghost_node_item)
	if inventory_item["count"] < 1:
		printerr("No item to place")
		clear_ghost()
		return
	
	var building: Node2D = load("res://objects/builds/%s.tscn" % _ghost_node_item).instantiate()
	if _ghost_node_item == "piston":
		building.direction = data["direction"]
	%BuildGrid.add_child(building)
	building.global_position = data["position"]
	
	inventory.increase(_ghost_node_item, -1)
	%Toolbar.init_inventory(inventory.items)
	if inventory.get_inventory_item(_ghost_node_item)["count"] <= 0:
		clear_ghost()
	
	SC.recompute_space_platform_size.emit()

func clear_ghost():
	if !_ghost_node:
		return
	_ghost_node.queue_free()
	_ghost_node = null
	_ghost_node_item = ""
	%Camera2D.is_drag_allowed = true
	SC.enable_no_tooltip_mode.emit(false)

func handle_power_production_increase(amount: int) -> void:
	power_production += amount
	SC.power_stats_changed.emit()

func handle_power_consumption_increase(amount: int) -> void:
	power_consumption += amount
	SC.power_stats_changed.emit()

func handle_increase_inventory_item(item_type: String, amount: int) -> void:
	inventory.increase(item_type, amount)
	%Toolbar.init_inventory(inventory.items)

func handle_increase_mining_speed():
	ore_miner.mining_rate_per_sec *= 2.0
	crystal_miner.mining_rate_per_sec *= 2.0
	water_miner.mining_rate_per_sec *= 2.0

class ResourceMiner:
	var planet_buffer: float = 0.0
	var mining_rate_per_sec: float = 10.0
	var item_type: String
	
	var previous_round_robin_index = -1
	
	func _init(item_type: String) -> void:
		self.item_type = item_type
	
	func process(dt: float) -> void:
		planet_buffer += dt * mining_rate_per_sec
		try_dump_buffer_to_landing_pad()
	
	func try_dump_buffer_to_landing_pad() -> void:
		var game = SC.game
		var landing_pads = game.get_tree().get_nodes_in_group("landing_pads")
		var matching_landing_pads = landing_pads.filter(func(l):
			return l.recipe.size() > 0 and l.recipe["item_type"] == item_type
		)
		if matching_landing_pads.size() == 0:
			return
		var items_to_dump = matching_landing_pads.front().recipe["item_count"]
		if (self.planet_buffer < items_to_dump):
			return
		self.previous_round_robin_index = wrapi(self.previous_round_robin_index + 1, 0, matching_landing_pads.size())
		var target_pad = matching_landing_pads[self.previous_round_robin_index]
		target_pad.inventory.increase(self.item_type, items_to_dump)
		self.planet_buffer -= items_to_dump
		
