class_name SideEffectHandler extends Node

var _inventory: Inventory


func _enter_tree() -> void:
	GlobalServiceRequests.side_effect.connect(_process_side_effect)
	GlobalServiceRequests.backpack_ready.connect(func(inv): _inventory = inv)


func _process_side_effect(side_effect: SideEffect) -> void:
	match side_effect.type:
		SideEffect.Type.GOT_ITEM:
			var item := Item.item_from_type(side_effect.args[0])
			if item and _inventory:
				_inventory.add(item, int(side_effect.args[1]))
			else:
				print_debug("Cannot process side effect due to null backpack")
