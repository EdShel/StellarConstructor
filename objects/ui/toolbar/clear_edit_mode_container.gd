extends Control


func _ready() -> void:
	visible = false
	SC.toolbar_item_placing_begin.connect(show_button)
	SC.toolbar_item_dismiss.connect(hide_button)


func show_button(item_type: String) -> void:
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)

func hide_button() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	tween.tween_callback(func() -> void: visible = false)

func _on_button_pressed() -> void:
	SC.toolbar_item_dismiss.emit()
