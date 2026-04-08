extends CollectibleItem

func on_collect():
	if Inventory.player.lantern:
		Inventory.player.lantern.add_battery()
		# Do not add to inventory if used for lantern? 
		# Or maybe we still want to track it.
		# For now let's just use it for the lantern.
		return

	Inventory.update_power_cells.emit()
	
static func use_item():
	Inventory.player.get_node("Head/Camcorder").try_to_recharge()
