extends Sprite2D

var type = "warning"

func _ready() -> void:
	if type == "no_power":
		texture = preload("res://sprites/statuses/no_power.png")
	%WarningPlayer.play("sway")
