extends Node2D
class_name Solar

@export var power_production = 15

func _ready() -> void:
	SC.increase_power_production.emit(power_production)

func _exit_tree() -> void:
	SC.increase_power_production.emit(-power_production)
