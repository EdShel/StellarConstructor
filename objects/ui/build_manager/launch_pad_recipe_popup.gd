extends BasePopup
class_name LaunchPadRecipePopup

var current_recipe_item: String = ""

func _ready() -> void:
	for planet in SC.game.planets:
		var recipe = preload("res://objects/ui/build_manager/recipe_item.tscn").instantiate()
		recipe.item_type = planet.result_item
		recipe.item_count = planet.send_rocket_threshold
		recipe.icon = ItemHelper.get_item_icon(planet.result_item)
		recipe.recipe_name = "%s x%s" % [ItemHelper.get_item_name(planet.result_item), planet.send_rocket_threshold]
		recipe.clicked.connect(handle_recipe_clicked)
		recipe.is_checked = current_recipe_item == planet.result_item
		%RecipesList.add_child(recipe)
	
func handle_recipe_clicked(recipe: ToolbarItem) -> void:
	var data = {
		"recipe_name": recipe.recipe_name,
		"icon": recipe.icon,
		"item_type": recipe.item_type,
		"item_count": recipe.item_count,
	}
	closed.emit(data)
