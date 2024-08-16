extends Control

var _count: int = 0

func set_count(value: int) -> void:
	%CountLabel.text = str(value)
	_count = value
	
func get_count() -> int:
	return _count
