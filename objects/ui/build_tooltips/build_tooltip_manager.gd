extends Control

var active_tooltip_target: Node2D = null
var active_tooltip_control: Control = null

func _ready() -> void:
	SC.show_build_tooltip.connect(handle_show_build_tooltip)
	SC.hide_build_tooltip.connect(handle_hide_build_tooltip)

func _process(_delta: float) -> void:
	if active_tooltip_target and not is_instance_valid(active_tooltip_target):
		clear_current_tooltip()

func handle_show_build_tooltip(item_type: String, node: Node2D) -> void:
	if node == active_tooltip_target:
		return
	
	if active_tooltip_target:
		clear_current_tooltip()
		
	
	if item_type == "landing_pad":
		active_tooltip_control = preload("res://objects/ui/build_tooltips/landing_pad_build_tooltip.tscn").instantiate()
		active_tooltip_control.landing_pad = node 
	
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
