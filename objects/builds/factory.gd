extends Node2D

@export var power_consumption = 4
var no_power: Node2D = null

var inventory: Inventory = Inventory.new([])

var recipe: FactoryRecipe = null
var crafting_state: CraftingState = null

func _ready() -> void:
	SC.power_stats_changed.connect(update_power_status)
	SC.increase_power_consumption.emit(power_consumption)

func _exit_tree() -> void:
	SC.increase_power_consumption.emit(-power_consumption)

func _process(delta: float) -> void:
	if !recipe or crafting_state:
		return
	
	if not have_enough_ingredients():
		return
	
	for ingredient in recipe.ingredients:
		inventory.increase(ingredient.item, -ingredient.count)
	
	crafting_state = CraftingState.new(recipe)
	%CraftingAnimation.speed_scale = 1.0 / recipe.crafting_duration_seconds
	%CraftingAnimation.play("craft")

func have_enough_ingredients() -> bool:
	for ingredient in recipe.ingredients:
		var item = inventory.find_inventory_item(ingredient.item)
		if item.is_empty() or item["count"] < ingredient.count:
			return false
	return true

func complete_crafting() -> void:
	var is_toolbelt_item = (
		recipe.result_item == "piston"
		or recipe.result_item == "solar"
		or recipe.result_item == "factory"
		or recipe.result_item == "landing_pad")
	if is_toolbelt_item:
		SC.increase_inventory_item.emit(recipe.result_item, recipe.result_count)
		return
	if recipe.result_item == "mining":
		SC.increase_mining_speed.emit()
		return
	
	inventory.increase(recipe.result_item, recipe.result_count)
	
func _on_crafting_animation_animation_finished(anim_name: StringName) -> void:
	crafting_state = null
	
func get_item_to_shoot() -> String:
	if not recipe:
		if inventory.items.is_empty():
			return ""
		for item in inventory.items:
			if item["count"] > 0:
				return item["item"]
		return ""
	
	var result_inventory = inventory.find_inventory_item(recipe.result_item)
	if result_inventory.is_empty() or result_inventory["count"] < 1:
		return ""
	return recipe.result_item


func update_power_status() -> void:
	var game = SC.game
	if game.power_consumption > game.power_production and !no_power:
		no_power = preload("res://objects/builds/utilities/warning.tscn").instantiate()
		no_power.type = "no_power"
		add_child(no_power)
		return
	if game.power_consumption <= game.power_production and no_power:
		no_power.queue_free()
		no_power = null

class CraftingState:
	var recipe: FactoryRecipe
	
	func _init(recipe: FactoryRecipe) -> void:
		self.recipe = recipe
