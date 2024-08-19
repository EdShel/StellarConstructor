extends Node2D

var type = "warning"

func _ready() -> void:
	if type == "no_power":
		%Sprite.texture = preload("res://sprites/statuses/no_power.png")
	%WarningPlayer.play("sway")
