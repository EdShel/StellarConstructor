extends Panel

func _ready() -> void:
	SC.connect("power_stats_changed", rerender_progress)
	rerender_progress()
	%Status.visible = false

func rerender_progress() -> void:
	var game = SC.game
	%ProductionIndicator.max_value = game.power_goal
	%ConsumptionIndicator.max_value = game.power_goal
	
	%ProductionIndicator.value = game.power_production
	%ConsumptionIndicator.value = game.power_consumption
	
	var template = "Consumption %sGW, Production %sGW, Goal %sGW"
	%Status.text = template % [game.power_consumption, game.power_production, game.power_goal]
	pass


func _on_mouse_entered() -> void:
	%Status.visible = true

func _on_mouse_exited() -> void:
	%Status.visible = false
