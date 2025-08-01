class_name Backpack extends Node

const PATH := "user://backpack.res"

@export var inventory_ui: InventoryUI

var inventory: Inventory


func _ready() -> void:
	inventory = Inventory.restore(PATH)
	if inventory_ui:
		inventory_ui.inventory = inventory

	GlobalServiceRequests.backpack_ready.emit(inventory)
