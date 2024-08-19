extends Node2D

signal direction_change_needed(direction: Piston.Direction)

var is_monitoring_enabled: bool = true

func set_monitoring_enabled(is_enabled: bool) -> void:
	is_monitoring_enabled = is_enabled
	for area: Area2D in get_children():
		area.monitoring = is_enabled

func _physics_process(_delta: float) -> void:
	if !is_monitoring_enabled:
		return
	
	var preferred_direction = "None"
	for area: Area2D in get_children():
		var areas = area.get_overlapping_areas()
		var can_connect = areas.any(func(a: Area2D) -> bool:
			var building = a.get_parent()
			return !!building.get("inventory") and not is_instance_of(building, Piston)
		)
		if can_connect :
			if preferred_direction == "None":
				preferred_direction = area.name
				continue
			preferred_direction = "Not sure"
	
	if preferred_direction == "Up":
		direction_change_needed.emit(Piston.Direction.DOWN)
		return
	if preferred_direction == "Down":
		direction_change_needed.emit(Piston.Direction.UP)
		return
	if preferred_direction == "Left":
		direction_change_needed.emit(Piston.Direction.RIGHT)
		return
	if preferred_direction == "Right":
		direction_change_needed.emit(Piston.Direction.LEFT)
		return
