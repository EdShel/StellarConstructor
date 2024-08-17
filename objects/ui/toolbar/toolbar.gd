extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_inventory(inventory: Array[Dictionary]) -> void:
	for child in get_children():
		var inventory_items = inventory.filter(func(x): return x["item"] == child.name)
		if inventory_items.size() == 0:
			printerr("Not found inventory for %s" % child.name)
			continue
		var item = inventory_items.front()
		child.set_count(item["count"])
		
