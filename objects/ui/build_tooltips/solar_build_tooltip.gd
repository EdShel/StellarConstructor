extends Control

var solar: Solar = null

func _enter_tree() -> void:
	if !solar:
		return
	%PowerProductionLabel.text = "%sGW" % solar.power_production
