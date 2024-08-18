class_name ItemHelper

static func get_item_icon(item: String) -> Texture2D:
	return load("res://sprites/items/%s.tres" % item)
