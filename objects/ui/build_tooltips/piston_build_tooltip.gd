extends Control

var piston: Piston = null

func _enter_tree() -> void:
	if !piston:
		return
	%PowerConsumption.power_consumption = piston.power_consumption
	%NoPower.visible = !!piston.no_power
	%NoSource.visible = !piston.source
	
	%BuildInventory.inventory = piston.inventory
	handle_piston_inventory_changed()
	piston.inventory.changed.connect(handle_piston_inventory_changed)

func handle_piston_inventory_changed() -> void:
	%BuildInventory.visible = !piston.inventory.is_empty()
