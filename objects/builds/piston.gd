extends Node2D
class_name Piston

enum Direction {
	RIGHT,
	LEFT,
	UP,
	DOWN,
}

var _direction: Direction = Direction.RIGHT

@export var power_consumption = 1
@export var direction: Direction:
	get: return _direction
	set(value): update_direction(value)

var source: Node2D = null

func _ready() -> void:
	SC.increase_power_consumption.emit(power_consumption)
	update_direction(direction)

func _exit_tree() -> void:
	SC.increase_power_consumption.emit(-power_consumption)

func update_direction(new_direction: Direction) -> void:
	_direction = new_direction
	%SourceScanner.position = get_source_scanner_position()
	%Sprite2D.texture = get_source_scanner_texture()

func get_source_scanner_position() -> Vector2:
	if direction == Direction.LEFT:
		return Vector2(64, 0)
	if direction == Direction.RIGHT:
		return Vector2(-64, 0)
	if direction == Direction.UP:
		return Vector2(0, 64)
	return Vector2(0, -64)
	
func get_source_scanner_texture() -> Texture2D:
	if direction == Direction.LEFT:
		return load("res://sprites/builds/piston_left.tres")
	if direction == Direction.RIGHT:
		return load("res://sprites/builds/piston.tres")
	if direction == Direction.UP:
		return load("res://sprites/builds/piston_up.tres")
	return load("res://sprites/builds/piston_down.tres")

func _on_source_scanner_area_entered(area: Area2D) -> void:
	source = area.get_parent()

func _on_source_scanner_area_exited(area: Area2D) -> void:
	if area.get_parent() == source:
		source = null
