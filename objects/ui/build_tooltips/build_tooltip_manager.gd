extends Control

var active_tooltip_target: Node2D = null
var active_tooltip_control: Control = null
var no_tooltip_mode_enabled = false

func _ready() -> void:
	SC.show_build_tooltip.connect(handle_show_build_tooltip)
	SC.hide_build_tooltip.connect(handle_hide_build_tooltip)
	SC.enable_no_tooltip_mode.connect(handle_no_tooltip_mode_enabled)

func _process(_delta: float) -> void:
	if active_tooltip_target and not is_instance_valid(active_tooltip_target):
		clear_current_tooltip()

func handle_show_build_tooltip(item_type: String, node: Node2D) -> void:
	if node == active_tooltip_target or no_tooltip_mode_enabled:
		return
	
	if active_tooltip_target:
		clear_current_tooltip()
		
	
	if item_type == "landing_pad":
		active_tooltip_control = preload("res://objects/ui/build_tooltips/landing_pad_build_tooltip.tscn").instantiate()
		active_tooltip_control.landing_pad = node
	elif item_type == "factory":
		active_tooltip_control = preload("res://objects/ui/build_tooltips/factory_build_tooltip.tscn").instantiate()
		active_tooltip_control.factory = node
	
	if not active_tooltip_control:
		return
		
	active_tooltip_target = node
	add_child(active_tooltip_control)

func clear_current_tooltip() -> void:
	active_tooltip_control.queue_free()
	active_tooltip_control = null
	active_tooltip_target = null

func handle_hide_build_tooltip(_item_type: String, node: Node2D) -> void:
	if node == active_tooltip_target:
		clear_current_tooltip()

func handle_no_tooltip_mode_enabled(enable: bool) -> void:
	no_tooltip_mode_enabled = enable
	if enable and active_tooltip_control:
		clear_current_tooltip()
