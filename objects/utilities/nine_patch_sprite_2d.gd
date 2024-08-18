@tool
extends Sprite2D

func _ready() -> void:
	set_notify_transform(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED and texture:
		material.set('shader_parameter/iResolution', scale * texture.get_size())
