extends Node2D
class_name LandingPad

var inventory: Inventory = Inventory.new([])

var _recipe: Dictionary = {}
var recipe: Dictionary:
	get: return _recipe
	set(value): update_recipe(value)

var no_recipe: Node2D = null
var is_landing_rocket: bool = false

func _ready() -> void:
	update_recipe(recipe)

func update_recipe(new_recipe: Dictionary) -> void:
	_recipe = new_recipe
	if !_recipe and !no_recipe:
		no_recipe = preload("res://objects/builds/utilities/warning.tscn").instantiate()
		add_child(no_recipe)
		return
	if _recipe and no_recipe:
		no_recipe.queue_free()
		no_recipe = null
		return

func get_item_to_shoot() -> String:
	if recipe.is_empty():
		if inventory.items.is_empty():
			return ""
		return inventory.items.front()["item"]
	var recipe_item = inventory.find_inventory_item(recipe["item_type"])
	if not recipe_item.is_empty() and recipe_item["count"] > 0:
		return recipe_item["item"]
	
	for item in inventory.items:
		if item["item"] != recipe["item_type"] and item["count"] > 0:
			return item["item"]
	
	return ""

func accept_rocket(item_type: String, item_count: int) -> void:
	var rocket = preload("res://objects/visuals/rocket.tscn").instantiate()
	rocket.offloading.connect(func() -> void:
		inventory.increase(item_type, item_count)	
	)
	rocket.tree_exited.connect(func() -> void:
		is_landing_rocket = false
	)
	%RocketSlot.add_child(rocket)
	is_landing_rocket = true
