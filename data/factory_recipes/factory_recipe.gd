class_name FactoryRecipe

var ingredients: Array[Ingredient]
var result_item: String
var result_count: int
var crafting_duration_seconds: float
var title: String
var description: String

func _init(
	ingredients: Array[Ingredient],
	result_item: String,
	result_count: int,
	crafting_duration_seconds: float,
	title: String,
	description: String
) -> void:
	self.ingredients = ingredients
	self.result_item = result_item
	self.result_count = result_count
	self.crafting_duration_seconds = crafting_duration_seconds
	self.title = title
	self.description = description

static func create_recipes() -> Array[FactoryRecipe]:
	return [
		FactoryRecipe.new(
			[
				Ingredient.new("ore", 10),
				Ingredient.new("water", 1),
			],
			"ingot", # result
			1,       # count
			4.0,     # duration
			"Ingot",
			"Use hydrogen fuel to smelt minerals into useful ingots. Has no byproducts because they are dropped into the star."
		),
		FactoryRecipe.new(
			[
				Ingredient.new("ingot", 1),
			],
			"circuit", # result
			1,         # count
			1.0,        # duration
			"Electronics",
			"Weld ingots into electrical circuitry. They make computers smort."
		),
		FactoryRecipe.new(
			[
				Ingredient.new("ingot", 1),
				Ingredient.new("circuit", 5),
			],
			"piston",  # result
			1,         # count
			2.0,        # duration
			"Gravity Piston",
			"Electric machine capable of safe item transferring in the solar orbit. Can receive and shoot resources from Rocket Landing Pad and Space Factory."
		),
		FactoryRecipe.new(
			[
				Ingredient.new("ingot", 10),
				Ingredient.new("circuit", 5),
				Ingredient.new("water", 100),
			],
			"factory",  # result
			1,          # count
			2.0,         # duration
			"Space Factory",
			"Electric machine designed to construct various things. You are interacting with one right now."
		),
		FactoryRecipe.new(
			[
				Ingredient.new("ingot", 100),
			],
			"landing_pad",    # result
			1,                # count
			5.0,               # duration
			"Rocket Landing Pad",
			"Receives raw resources from your stellar colonies. If 2+ landing pads expect the same resource, it will be delivered using round-robin algorithm."
		),
		FactoryRecipe.new(
			[
				Ingredient.new("crystal", 5),
				Ingredient.new("water", 1),
			],
			"glass",          # result
			5,                # count
			0.5,              # duration
			"Glass x5",
			"Intermediate resource required for Solar Panels. If you expect pistons to break it, then don't - this glass is very strong."
		),
		FactoryRecipe.new(
			[
				Ingredient.new("glass", 10),
				Ingredient.new("circuit", 1),
				Ingredient.new("ingot", 1),
			],
			"solar",          # result
			1,                # count
			1.0,               # duration
			"Solar Panel",
			"Generates electricity, duh. To warp to your home system and achieve the victory, you need to build a lot of these."
		),
		FactoryRecipe.new(
			[
				Ingredient.new("crystal", 10),
				Ingredient.new("circuit", 1),
				Ingredient.new("water", 1),
			],
			"mining",         # result
			1,                # count
			10.0,              # duration
			"Colony Drilling Efficiency",
			"Rockets arrive to landing pads faster due to increased mining speed. Not required to finish the game but useful for megabases which are BUILT TO SCALE."
		),
	]

class Ingredient:
	var item: String
	var count: int

	func _init(item = "ore", count = 1) -> void:
		self.item = item
		self.count = count
