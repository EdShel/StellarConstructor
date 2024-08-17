extends TextureRect

@export var icon: Texture2D:
	get: return texture
	set(value): texture = value
@export var count: int:
	get: return 0
	set(value):
		%IngredientCount.text = "x%s" % value
