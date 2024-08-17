extends Node

var game: Node2D = null

signal game_changed(game: Node)

signal toolbar_item_pressed(item_type: String)
signal toolbar_item_place(at: Vector2)

signal increase_power_production(amount: int)
signal increase_power_consumption(amount: int)
signal power_stats_changed()

signal increase_inventory_item(item_type: String, amount: int)

func set_game(new_game: Node2D) -> void:
	game = new_game
	if new_game:
		game_changed.emit(game)
