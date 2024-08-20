extends PanelContainer

var landing_pad: LandingPad = null
var progress_planet: PlanetConfig = null

func _enter_tree() -> void:
	if !landing_pad:
		return
	if not landing_pad.recipe.is_empty():
		%RecipeIcon.texture = ItemHelper.get_item_icon(landing_pad.recipe["item_type"])
		%RecipeName.text = ItemHelper.get_item_name(landing_pad.recipe["item_type"])
		var planets = SC.game.planets.filter(func(p: PlanetConfig) -> bool: return p.result_item == landing_pad.recipe["item_type"])
		if not planets.is_empty():
			progress_planet = planets.front()
			%MiningProgress.max_value = progress_planet.send_rocket_threshold
	else:
		%RecipeIcon.texture = preload("res://sprites/statuses/warning.png")
		%RecipeName.text = "Click to specify delivery resource"
		%MiningProgress.visible = false
	
	%BuildInventory.inventory = landing_pad.inventory
	
func _process(_delta: float) -> void:
	if not progress_planet:
		return
	%MiningProgress.value = progress_planet.planet_buffer
