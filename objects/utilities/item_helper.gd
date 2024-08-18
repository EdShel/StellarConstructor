class_name ItemHelper

static func get_item_icon(item: String) -> Texture2D:
	return load("res://sprites/items/%s.tres" % item)

static func get_item_name(item: String) -> String:
	if item == "ore":
		return "Minerals"
	if item == "crystal":
		return "Crystals"
	if item == "water":
		return "Liquid Hydrogen"
	return item
