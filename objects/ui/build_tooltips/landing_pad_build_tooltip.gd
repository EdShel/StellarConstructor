extends PanelContainer

var landing_pad: LandingPad = null

func _enter_tree() -> void:
	if !landing_pad:
		return
	if not landing_pad.recipe.is_empty():
		%RecipeIcon.texture = ItemHelper.get_item_icon(landing_pad.recipe["item_type"])
		%RecipeName.text = ItemHelper.get_item_name(landing_pad.recipe["item_type"])
	else:
		%RecipeIcon.texture = preload("res://sprites/statuses/warning.png")
		%RecipeName.text = "Specify delivery resource"
	
	%BuildInventory.inventory = landing_pad.inventory
	
