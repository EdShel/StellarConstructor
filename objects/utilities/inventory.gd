class_name Inventory

signal changed()

var items: Array[Dictionary] = []

func _init(init_items: Array[Dictionary]) -> void:
	self.items = init_items

func find_inventory_item(item: String) -> Dictionary:
	var found_items = items.filter(func(i: Dictionary): return i["item"] == item)
	if found_items.size() > 0:
		return found_items[0]
	return {}

func get_inventory_item(item: String) -> Dictionary:
	var found_items = items.filter(func(i: Dictionary): return i["item"] == item)
	if found_items.size() > 0:
		return found_items[0]
	return { "item": item, "count": 0 }

func increase(item: String, amount: int) -> void:
	var entry = find_inventory_item(item)
	if entry.is_empty():
		items.push_back({
			"item": item,
			"count": amount,
		})
		changed.emit()
		return
	entry["count"] += amount
	changed.emit()
