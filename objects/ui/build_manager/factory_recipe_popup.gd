extends BasePopup
class_name FactoryRecipePopup

func _ready() -> void:
	for recipe in FactoryRecipe.create_recipes():
		var recipe_item = preload("res://objects/ui/build_manager/factory_recipe_item.tscn").instantiate()
		recipe_item.recipe = recipe
		recipe_item.clicked.connect(func() -> void:
			closed.emit({ "recipe": recipe })
		)
		%Recipes.add_child(recipe_item)
		
