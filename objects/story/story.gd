extends Node2D

var slide_number = 1
var last_slide_number = 12

func _ready() -> void:
	%Sprite.texture = get_slide_texture(slide_number)

func _unhandled_input(event: InputEvent) -> void:
	if (
		(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT)
		or (event.is_action_pressed("right"))
	):
		get_viewport().set_input_as_handled()
		next_slide()
		return
	
	if (
		(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT)
		or (event.is_action_pressed("left"))
	):
		get_viewport().set_input_as_handled()
		prev_slide()
		return

func next_slide() -> void:
	slide_number += 1
	if slide_number > last_slide_number:
		get_tree().change_scene_to_file("res://objects/game.tscn")
		return
	update_slide()

func prev_slide() -> void:
	slide_number = max(1, slide_number - 1)
	update_slide()

func update_slide() -> void:
	%Sprite.texture = get_slide_texture(slide_number)
	%SlideNumber.text = "%s/%s" % [slide_number, last_slide_number]

func get_slide_texture(number: int) -> Texture2D:
	return load("res://sprites/story/story%s.png" % number)
