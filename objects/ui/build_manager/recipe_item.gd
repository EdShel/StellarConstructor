extends Control

@export var recipe_name: String:
	get: return %Label.text
	set(value): %Label.text = value
@export var icon: Texture2D:
	get: return %Icon.texture
	set(value): %Icon.texture = value
