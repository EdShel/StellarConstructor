extends Control

var inventory: Inventory = null

func _ready() -> void:
	if !inventory:
		return
	
	refresh_inventory(inventory)
	inventory.changed.connect(func() -> void: refresh_inventory(self.inventory))


func refresh_inventory(inventory: Inventory) -> void:
	for child in %Items.get_children():
		child.queue_free()
	
	for item in inventory.items:
		if item["count"] < 1:
			continue
		var i = preload("res://objects/ui/build_tooltips/inventory/build_inventory_item.tscn").instantiate()
		i.item = item
		%Items.add_child(i)
	
	if %Items.get_child_count() > 0:
		%Label.text = "Inventory"
	else:
		%Label.text = "Inventory is empty"
