extends Node

var game: Game = null

signal game_changed(game: Node)

signal toolbar_item_pressed(item_type: String)
signal toolbar_item_placing_begin(item_type: String)
signal toolbar_item_place(data: Dictionary)
signal toolbar_item_dismiss()
signal build_destroyed()

signal recompute_space_platform_size()

signal increase_power_production(amount: int)
signal increase_power_consumption(amount: int)
signal power_stats_changed()

signal increase_inventory_item(item_type: String, amount: int)
signal increase_mining_speed()

signal open_build(item_type: String, node: Node2D)

signal show_build_tooltip(item_type: String, node: Node2D)
signal hide_build_tooltip(item_type: String, node: Node2D)
signal enable_no_tooltip_mode(enable: bool)

signal piston_added(piston: Piston)
signal piston_removed(piston: Piston)

func set_game(new_game: Game) -> void:
	game = new_game
	if new_game:
		game_changed.emit(game)
