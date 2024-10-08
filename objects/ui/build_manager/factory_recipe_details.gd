extends Control

var recipe: FactoryRecipe = null

func _ready() -> void:
	if !recipe:
		return
	%Icon.texture = load("res://sprites/items/%s.tres" % recipe.result_item)
	%Title.text = recipe.title
	%Description.text = recipe.description
	
	var i = 0
	for ingredient in recipe.ingredients:
		var ingredient_item = preload("res://objects/ui/build_manager/factory_ingredient.tscn").instantiate()
		ingredient_item.icon = load("res://sprites/items/%s.tres" % ingredient.item)
		ingredient_item.count = ingredient.count
		%Ingredients.add_child(ingredient_item)
		%Ingredients.move_child(ingredient_item, i)
		i += 1
		
	%Duration.text = "%ss" % recipe.crafting_duration_seconds
