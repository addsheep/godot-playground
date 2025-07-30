class_name Backpack extends Node

const PATH := "user://backpack.res"

@export var inventory_ui: InventoryUI

var _inventory: Inventory


func _ready() -> void:
	_inventory = Inventory.restore(PATH)
	if inventory_ui:
		inventory_ui.inventory = _inventory


## Dialog custom callbacks
func add(type: String, amount: String) -> void:
	var item: Item = Item.item_from_type(type)
	if item:
		_inventory.add(item, int(amount))


func remove(type: String, amount: String) -> void:
	_inventory.remove(type, int(amount))


func has_at_least(type: String, amount: String) -> bool:
	return _inventory.get_item_count(type) >= int(amount)
