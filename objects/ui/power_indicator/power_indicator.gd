extends Panel

var tween: Tween = null

func _ready() -> void:
	SC.connect("power_stats_changed", rerender_progress)
	rerender_progress(true)
	%Status.modulate = Color.TRANSPARENT

func rerender_progress(dont_blink_status: bool = false) -> void:
	var game = SC.game
	%ProductionIndicator.max_value = game.power_goal
	%ConsumptionIndicator.max_value = game.power_goal
	
	%ProductionIndicator.value = game.power_production
	%ConsumptionIndicator.value = game.power_consumption
	
	var template = "Consumption %sGW, Production %sGW, Goal %sGW"
	%Status.text = template % [game.power_consumption, game.power_production, game.power_goal]
	
	if not dont_blink_status:
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(%Status, "modulate", Color.WHITE, 0.2)
		tween.tween_property(%Status, "modulate", Color.TRANSPARENT, 0.2).set_delay(3.0)



func _on_mouse_entered() -> void:
	if tween:
		tween.stop()
		tween = null
	var t = create_tween()
	t.tween_property(%Status, "modulate", Color.WHITE, 0.2)

func _on_mouse_exited() -> void:
	if tween:
		tween.stop()
		tween = null
	var t = create_tween()
	t.tween_property(%Status, "modulate", Color.TRANSPARENT, 0.2)
