extends Node2D

var master_bus: int

func _ready() -> void:
	show_menu()
	master_bus = AudioServer.get_bus_index("Master")
	%SoundSlider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus)) * 100

func _on_start_clicked() -> void:
	get_tree().change_scene_to_file("res://objects/story/story.tscn")


func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value / 100.0))
	AudioServer.set_bus_mute(master_bus, value < 1)

func show_menu() -> void:
	%Menu.visible = true
	%Settings.visible = false
	
func show_settings() -> void:
	%Menu.visible = false
	%Settings.visible = true

func _on_settings_clicked() -> void:
	show_settings()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			show_menu()
			
func _on_menu_button_clicked() -> void:
	show_menu()


func _on_sound_slider_drag_ended(_value_changed: bool) -> void:
	%TestSound.play()


func _on_start_quick_clicked() -> void:
	get_tree().change_scene_to_file("res://objects/game.tscn")
