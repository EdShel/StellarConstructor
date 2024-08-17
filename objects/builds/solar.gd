extends Node2D

@export var power_production = 5

func _ready() -> void:
	SC.increase_power_production.emit(power_production)

func _exit_tree() -> void:
	SC.increase_power_production.emit(-power_production)
