extends Node2D

@export var power_consumption = 4
var no_power: Node2D = null

var inventory: Inventory = Inventory.new([])

func _ready() -> void:
	SC.power_stats_changed.connect(update_power_status)
	SC.increase_power_consumption.emit(power_consumption)

func _exit_tree() -> void:
	SC.increase_power_consumption.emit(-power_consumption)

func _process(delta: float) -> void:
	pass

func get_item_to_shoot() -> String:
	return ""

func update_power_status() -> void:
	var game = SC.game
	if game.power_consumption > game.power_production and !no_power:
		no_power = preload("res://objects/builds/utilities/warning.tscn").instantiate()
		no_power.type = "no_power"
		add_child(no_power)
		return
	if game.power_consumption <= game.power_production and no_power:
		no_power.queue_free()
		no_power = null
