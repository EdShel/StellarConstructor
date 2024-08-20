extends BasePopup
class_name FactoryRecipePopup

var current_recipe_item: String = ""

func _ready() -> void:
	for recipe in FactoryRecipe.create_recipes():
		var item_details = preload("res://objects/ui/build_manager/factory_recipe_details.tscn").instantiate()
		item_details.recipe = recipe
		item_details.visible = false
		%Details.add_child(item_details)
		
		var recipe_item = preload("res://objects/ui/build_manager/factory_recipe_item.tscn").instantiate()
		recipe_item.item_type = recipe.result_item
		recipe_item.is_checked = recipe.result_item == current_recipe_item
		recipe_item.clicked.connect(func() -> void:
			closed.emit({ "recipe": recipe })
		)
		recipe_item.hover_changed.connect(func(is_hovered: bool) -> void:
			item_details.visible = is_hovered
		)
		%Items.add_child(recipe_item)
		
