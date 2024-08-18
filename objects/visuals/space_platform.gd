extends Node2D

@export var min_size: Vector2 = Vector2(256, 256)
@export var bbox_padding: float = 128.0

func _ready() -> void:
	recompute_size(true)
	SC.recompute_space_platform_size.connect(recompute_size)
	

func recompute_size(no_animation: bool = false) -> void:
	var builds = get_tree().get_nodes_in_group("build")
	var bbox = compute_buildings_bbox(builds)
	bbox = bbox.grow(bbox_padding)
	var size = Vector2(
		max(min_size.x, bbox.size.x),
		max(min_size.y, bbox.size.y)
	)
	var center = bbox.get_center()
	var base_size = %Sprite.texture.get_size()
	var needed_scale = size / base_size
	
	if no_animation:
		%Sprite.scale = needed_scale
		global_position = center
	else:
		var tween = create_tween()
		tween.parallel().tween_property(%Sprite, "scale", needed_scale, 0.1)
		tween.parallel().tween_property(self, "global_position", center, 0.1)

func compute_buildings_bbox(nodes: Array[Node]) -> Rect2:
	var minX: float = INF
	var maxX: float = -INF
	var minY: float = INF
	var maxY: float = -INF
	for node in nodes:
		if node.is_queued_for_deletion():
			continue
		var pos = node.global_position
		if pos.x < minX:
			minX = pos.x
		if pos.y < minY:
			minY = pos.y
		if pos.x > maxX:
			maxX = pos.x
		if pos.y > maxY:
			maxY = pos.y
	
	if is_inf(minX):
		return Rect2(0, 0, 0, 0)
	return Rect2(minX, minY, maxX - minX, maxY - minY)
	
