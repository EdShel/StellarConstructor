extends Node2D
class_name Piston

enum Direction {
	RIGHT,
	LEFT,
	UP,
	DOWN,
}

var _direction: Direction = Direction.RIGHT
var shoot_direction: Vector2 = Vector2(1, 0)
var inventory: Inventory = Inventory.new([])

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
	SC.piston_added.emit(self)
	update_direction(direction)
	update_source(null)

func _exit_tree() -> void:
	SC.increase_power_consumption.emit(-power_consumption)
	SC.piston_removed.emit(self)

func try_shooting() -> void:
	if no_power or shooting_state:
		return
	
	var what_to_shoot: ShootingState = find_what_to_shoot()
	if what_to_shoot == null:
		return
	
	if what_to_shoot.item_source == ItemSource.MY_INVENTORY:
		inventory.increase(what_to_shoot.item_type, -1)
	elif what_to_shoot.item_source == ItemSource.SOURCE_BUILD:
		source.inventory.increase(what_to_shoot.item_type, -1)
		
	shooting_state = what_to_shoot
	%AnimationPlayer.play("shoot")

func find_what_to_shoot() -> ShootingState:
	for item in inventory.items:
		if item["count"] > 0:
			return ShootingState.new(item["item"], ItemSource.MY_INVENTORY)
	
	if not source:
		return null
	
	var source_item: String = source.get_item_to_shoot()
	if not source_item.is_empty():
		return ShootingState.new(source_item, ItemSource.SOURCE_BUILD)
		
	return null

func update_direction(new_direction: Direction) -> void:
	_direction = new_direction
	%SourceScanner.position = get_source_scanner_position()
	shoot_direction = get_shoot_direction()
	%Sprite2D.texture = get_piston_texture(new_direction)

func get_source_scanner_position() -> Vector2:
	if direction == Direction.LEFT:
		return Vector2(64, 0)
	if direction == Direction.RIGHT:
		return Vector2(-64, 0)
	if direction == Direction.UP:
		return Vector2(0, 64)
	return Vector2(0, -64)
	
func get_shoot_direction() -> Vector2:
	if direction == Direction.LEFT:
		return Vector2(-1, 0)
	if direction == Direction.RIGHT:
		return Vector2(1, 0)
	if direction == Direction.UP:
		return Vector2(0, -1)
	return Vector2(0, 1)
	
static func get_piston_texture(direction: Direction) -> Texture2D:
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
	if is_queued_for_deletion() or !%SourceScanner:
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

func shoot() -> void:
	if !shooting_state:
		printerr("Not shooting but got command to shoot")
		return
	var bullet = preload("res://objects/bullets/item_bullet.tscn").instantiate()
	bullet.parent = self
	bullet.direction = shoot_direction
	bullet.item_type = shooting_state.item_type
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	shooting_state = null

func get_item_to_shoot() -> String:
	return "" # Don't allow pistons to grab stuff from other pistons

enum ItemSource { NONE, MY_INVENTORY, SOURCE_BUILD }

class ShootingState:
	var item_type: String
	var item_source: ItemSource
	
	func _init(item_type: String, item_source: ItemSource) -> void:
		self.item_type = item_type
		self.item_source = item_source
