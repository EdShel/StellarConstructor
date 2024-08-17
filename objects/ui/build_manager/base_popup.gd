extends PanelContainer
class_name BasePopup

signal closed(result: Dictionary)

func _on_cancel_button_pressed() -> void:
	closed.emit({})
