extends Node2D

var inventory: Inventory = Inventory.new([])

var recipe: Dictionary = {}

func get_item_to_shoot() -> String:
	if recipe.is_empty():
		if inventory.items.is_empty():
			return ""
		return inventory.items.front()["item"]
	for item in inventory.items:
		if item["item"] != recipe["item_type"] and item["count"] > 0:
			return item["item"]
	
	var recipe_item = inventory.find_inventory_item(recipe["item_type"])
	if recipe_item.is_empty() or recipe_item["count"] <= 0:
		return ""
	return recipe_item["item"]
