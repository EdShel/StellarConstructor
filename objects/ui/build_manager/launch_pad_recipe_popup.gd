extends BasePopup
class_name LaunchPadRecipePopup

func _ready() -> void:
	for child in %RecipesList.get_children():
		child.clicked.connect(handle_recipe_clicked)


func handle_recipe_clicked(recipe: ToolbarItem) -> void:
	var data = {
		"recipe_name": recipe.recipe_name,
		"icon": recipe.icon,
		"item_type": recipe.item_type,
		"item_count": recipe.item_count,
	}
	closed.emit(data)
