extends PanelContainer

var factory: Factory = null

func _enter_tree() -> void:
	if !factory:
		return
	
	if factory.recipe:
		%RecipeIcon.texture = ItemHelper.get_item_icon(factory.recipe.result_item)
		%RecipeName.text = factory.recipe.title
	else:
		%RecipeIcon.texture = preload("res://sprites/statuses/warning.png")
		%RecipeName.text = "Specify crafting recipe"
	%CraftingProgress.visible = !!factory.recipe
	
	%PowerConsumption.power_consumption = factory.power_consumption
	%NoPower.visible = !!factory.no_power
	
	%BuildInventory.inventory = factory.inventory

func _process(delta: float) -> void:
	if !%CraftingProgress.visible or !factory:
		return
	
	if not factory.crafting_state:
		%CraftingProgress.value = 0
	else:
		%CraftingProgress.value = factory.crafting_state.time_spent / factory.crafting_state.recipe.crafting_duration_seconds * 100.0
		 
