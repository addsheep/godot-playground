extends Node

const PATH := "user://backpack.res"
const DB_PATH_PREFIX := "items/"

@export var inventory_ui: InventoryUI

var _inventory: Inventory


func _ready() -> void:
	_inventory = Inventory.restore(PATH)
	inventory_ui.inventory = _inventory


## Dialog custom callbacks
func add_str(args: Array) -> void:
	var item: Item = DatabaseUtils.load_res(DB_PATH_PREFIX + args[0])
	_inventory.add(item, int(args[1]))


func remove_str(args: Array) -> void:
	_inventory.remove(args[0], int(args[1]))


func has_at_least(args: Array) -> bool:
	return _inventory.get_item_count(args[0]) >= int(args[1])
