extends Node2D
class_name Game

var _ghost_node: Node2D = null
var _ghost_node_item: String = ""

var inventory: Inventory = Inventory.new([
	{
		"item": "solar",
		"count": 4,
	},
	{
		"item": "piston",
		"count": 5,
	},
	{
		"item": "factory",
		"count": 4,
	},
	{
		"item": "landing_pad",
		"count": 3,
	},
])

var power_goal = 500
var power_production = 0
var power_consumption = 0
var victory_shown = false
var victory_popup: Node = null

var planets: Array[PlanetConfig]
var miners: Array[ResourceMiner] = []

func _enter_tree() -> void:
	SC.connect("toolbar_item_pressed", handle_toolbar_item_pressed)
	SC.connect("toolbar_item_place", handle_toolbar_item_place)
	SC.connect("toolbar_item_dismiss", clear_ghost)
	SC.connect("build_destroyed", func() -> void: %BuildDestroySound.play())
	
	SC.connect("increase_power_production", handle_power_production_increase)
	SC.connect("increase_power_consumption", handle_power_consumption_increase)
	
	SC.connect("increase_inventory_item", handle_increase_inventory_item)
	SC.connect("increase_mining_speed", handle_increase_mining_speed)

	planets = PlanetConfig.create_planets()
	for planet in planets:
		var miner = ResourceMiner.new(planet)
		miners.push_back(miner)
	
	SC.set_game(self)

func _ready() -> void:
	%Toolbar.init_inventory(inventory.items)

func _exit_tree() -> void:
	SC.set_game(null)
	return # TODO: unsubscribe

func _process(delta: float) -> void:
	for miner in miners:
		miner.process(delta)

func handle_toolbar_item_pressed(item_type: String) -> void:
	if _ghost_node_item == item_type:
		SC.toolbar_item_dismiss.emit()
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
	SC.toolbar_item_placing_begin.emit(item_type)

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
		SC.toolbar_item_dismiss.emit()
	
	SC.recompute_space_platform_size.emit()
	%BuildPlaceSound.play()

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
	
	if power_production >= power_goal and !victory_shown:
		victory_shown = true
		victory_popup = preload("res://objects/ui/victory_popup/victory_popup.tscn").instantiate()
		victory_popup.closed.connect(func(_unused: Dictionary) -> void:
			victory_popup.queue_free()
			victory_popup = null
		)
		%VictorySlot.add_child(victory_popup)
		SC.toolbar_item_dismiss.emit()

func handle_power_consumption_increase(amount: int) -> void:
	power_consumption += amount
	SC.power_stats_changed.emit()

func handle_increase_inventory_item(item_type: String, amount: int) -> void:
	inventory.increase(item_type, amount)
	%Toolbar.init_inventory(inventory.items)

func handle_increase_mining_speed():
	for planet in planets:
		planet.mining_rate_per_sec *= 1.5

class ResourceMiner:
	var planet: PlanetConfig
	
	var previous_round_robin_index = -1
	
	func _init(planet: PlanetConfig) -> void:
		self.planet = planet
	
	func process(dt: float) -> void:
		if planet.planet_buffer < planet.planet_buffer_limit:
			planet.planet_buffer += dt * planet.mining_rate_per_sec
		try_dump_buffer_to_landing_pad()
	
	func try_dump_buffer_to_landing_pad() -> void:
		var game = SC.game
		var landing_pads = game.get_tree().get_nodes_in_group("landing_pads")
		var matching_landing_pads = landing_pads.filter(func(l):
			return l.recipe.size() > 0 and l.recipe["item_type"] == planet.result_item
		)
		if matching_landing_pads.size() == 0:
			return
		var items_to_dump = planet.send_rocket_threshold
		if (planet.planet_buffer < items_to_dump):
			return
		self.previous_round_robin_index = wrapi(self.previous_round_robin_index + 1, 0, matching_landing_pads.size())
		var target_pad = matching_landing_pads[self.previous_round_robin_index]
		if target_pad.is_landing_rocket:
			return
		target_pad.accept_rocket(planet.result_item, items_to_dump)
		planet.planet_buffer -= items_to_dump
		
