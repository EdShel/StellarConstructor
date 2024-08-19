extends Node2D

func _on_child_entered_tree(node: Node) -> void:
	layout_children()

func _on_child_exiting_tree(node: Node) -> void:
	layout_children(node)

func layout_children(except: Node = null) -> void:
	var child_size = 48.0
	var children_gap = 4.0
	
	var children = get_children()
	if except:
		children.erase(except)
	
	var children_count = children.size()
	if children_count == 0:
		return
	if children_count == 1:
		var tween = create_tween()
		tween.tween_property(children[0], "position", Vector2(0.0, 0.0), 0.2)
		return
	if children_count == 2:
		var tween = create_tween()
		tween.parallel().tween_property(children[0], "position", Vector2(-child_size / 2.0 - children_gap, 0.0), 0.2)
		tween.parallel().tween_property(children[1], "position", Vector2(child_size / 2.0 + children_gap, 0.0), 0.2)
		return
