extends Control

var solar: Solar = null

func _enter_tree() -> void:
	if !solar:
		return
	%PowerProductionLabel.text = "%sW" % solar.power_production
