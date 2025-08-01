class_name Backpack extends Node

const PATH := "user://backpack.res"

@export var inventory_ui: InventoryUI

var inventory: Inventory


func _ready() -> void:
	inventory = Inventory.restore(PATH)
	if inventory_ui:
		inventory_ui.inventory = inventory

	GlobalServiceRequests.backpack_ready.emit(self)


#region Dialo(madtalk) g custom callbacks
func add(type: String, amount: String) -> void:
	var item: Item = Item.item_from_type(type)
	if item:
		inventory.add(item, int(amount))


func remove(type: String, amount: String) -> void:
	inventory.remove(type, int(amount))


func has_at_least(type: String, amount: String) -> bool:
	return inventory.get_item_count(type) >= int(amount)
#endregion
