extends Sprite2D

signal offloading()

func _ready() -> void:
	%AnimationPlayer.play("landing")

func offload() -> void:
	offloading.emit()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
