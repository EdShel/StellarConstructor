@tool
extends Sprite2D

var prev_scale: Vector2

func _ready() -> void:
	set_notify_transform(true)
	prev_scale = global_scale

func _process(_delta: float) -> void:
	if prev_scale != global_scale:
		update_shader()
		prev_scale = global_scale
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		update_shader()

func update_shader() -> void:
	if texture:
		material.set('shader_parameter/iResolution', global_scale * texture.get_size())
	
