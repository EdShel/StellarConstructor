extends PanelContainer
class_name BasePopup

signal closed(result: Dictionary)

@export var title: String = "TITLE"
@export var subtitle: String = "SUBTITLE"

func _ready() -> void:
	%Title.text = title
	%Subtitle.text = subtitle

func _on_cancel_button_pressed() -> void:
	closed.emit({})
