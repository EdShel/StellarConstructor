extends Node2D

@export var okColor: Color
@export var badColor: Color

var collisions_count: int = 0
var collision_safe_padding_pixels = 4
var item_type: String = "landing_pad"
var direction: Piston.Direction = Piston.Direction.RIGHT

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if collisions_count > 0:
		modulate = badColor
	else:
		modulate = okColor

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var world_coord = get_canvas_transform().affine_inverse() * event.position
		var snap_coord = snapped(world_coord, Vector2(64, 64))
		if %CollisionShape2D.shape.size.x > 64:
			snap_coord -= Vector2(32, 32) # I'm so sorry :(
		global_position = snap_coord
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		if collisions_count <= 0:
			SC.toolbar_item_place.emit({
				"position": global_position,
				"direction": direction,
			})
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			SC.toolbar_item_dismiss.emit()

func update(item_type: String):
	self.item_type = item_type
	
	var sprite: AtlasTexture = load("res://sprites/builds/%s.tres" % item_type)
	var size_pixels = sprite.region.size.x
	var size_grid = ceil(size_pixels / 64)
	%Sprite2D.texture = sprite
	
	%CollisionShape2D.shape.size = sprite.region.size - Vector2(2 * collision_safe_padding_pixels, 2 * collision_safe_padding_pixels)	
	%PistonSourceScanners.set_monitoring_enabled(item_type == "piston")

func _on_area_2d_area_entered(_area: Area2D) -> void:
	collisions_count += 1

func _on_area_2d_area_exited(_area: Area2D) -> void:
	collisions_count -= 1

func _on_piston_source_scanners_direction_change_needed(direction: Piston.Direction) -> void:
	self.direction = direction
	%Sprite2D.texture = Piston.get_piston_texture(direction)
