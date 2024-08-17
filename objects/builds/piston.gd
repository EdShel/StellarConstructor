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
var warning: Node2D = null
var no_power: Node2D = null

var shooting_state: ShootingState = null

func _ready() -> void:
	SC.power_stats_changed.connect(update_power_status)
	SC.increase_power_consumption.emit(power_consumption)
	update_direction(direction)
	update_source(null)

func _exit_tree() -> void:
	SC.increase_power_consumption.emit(-power_consumption)

func _process(delta: float) -> void:
	if !source or no_power or shooting_state:
		return
	shooting_state = ShootingState.new("ore")
	%AnimationPlayer.play("shoot")

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
		return load("res://sprites/builds/piston_right.tres")
	if direction == Direction.UP:
		return load("res://sprites/builds/piston_up.tres")
	return load("res://sprites/builds/piston_down.tres")

func _on_source_scanner_area_entered(area: Area2D) -> void:
	update_source(area.get_parent())

func _on_source_scanner_area_exited(area: Area2D) -> void:
	if area.get_parent() == source:
		update_source(null)

func update_source(new_source: Node2D) -> void:
	if !%SourceScanner:
		return # This node is destroying
		
	if new_source and !new_source.get("inventory"):
		new_source = null
	source = new_source
	if !source and !warning:
		warning = preload("res://objects/builds/utilities/warning.tscn").instantiate()
		%SourceScanner.add_child(warning)
		return
	if source and warning:
		warning.queue_free()
		warning = null

func update_power_status() -> void:
	var game = SC.game
	if game.power_consumption > game.power_production and !no_power:
		no_power = preload("res://objects/builds/utilities/warning.tscn").instantiate()
		no_power.type = "no_power"
		add_child(no_power)
		return
	if game.power_consumption <= game.power_production and no_power:
		no_power.queue_free()
		no_power = null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	shooting_state = null
	print("Shoot end")

class ShootingState:
	var item_type: String
	
	func _init(item_type: String) -> void:
		self.item_type = item_type
