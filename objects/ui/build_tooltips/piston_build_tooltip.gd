extends Control

var piston: Piston = null

func _enter_tree() -> void:
	if !piston:
		return
	%PowerConsumption.power_consumption = piston.power_consumption
	%NoPower.visible = !!piston.no_power
	%NoSource.visible = !piston.source
