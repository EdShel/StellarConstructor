extends Control

var item: Dictionary = {}

func _ready() -> void:
	if item.is_empty():
		return
	%TextureRect.texture = ItemHelper.get_item_icon(item["item"])
	%Count.text = str(item["count"])
