extends Node2D

@export var item_type: String = "ore"
var ttl_seconds: float = 30.0
var speed: float = 64.0
var direction: Vector2 = Vector2(1, 0)
var is_dying = false

var parent: Node = null

func _ready() -> void:
	%Sprite2D.texture = load("res://sprites/items/%s.tres" % item_type)
	%AnimationPlayer.play("appear")

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	if is_dying:
		return
	
	ttl_seconds -= delta
	if ttl_seconds <= 0:
		become_destroying()

func _on_area_2d_area_entered(area: Area2D) -> void:
	var building = area.get_parent()
	if building == parent:
		return
	var inventory = building.get("inventory")
	if inventory:
		inventory.increase(item_type, 1)
	become_destroying()

func become_destroying() -> void:
	%AnimationPlayer.play("consume")
	%Area2D.queue_free()
	is_dying = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if is_dying:
		queue_free()
