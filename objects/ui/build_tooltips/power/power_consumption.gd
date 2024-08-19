extends Control

var power_consumption: int = 1

func _ready() -> void:
	%Value.text = "%sGW" % power_consumption
