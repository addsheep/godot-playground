extends Control

@onready var inventory_ui: InventoryUI = $InventoryUi

var items: Array[Item] = [null, null]


func _ready() -> void:
	items[0] = Item.new()
	items[0].type = "Foo"
	items[0].display_name = "Foo name"
	items[0].icon = load("res://tests/assets/robot.png")
	inventory_ui.inventory.add(items[0], 2)

	items[1] = Item.new()
	items[1].type = "Bar"
	items[1].display_name = "Bar name"
	items[1].icon = load("res://tests/assets/robot.png")
	inventory_ui.inventory.add(items[1], 3)


func _add_new(index: int) -> void:
	if index < items.size():
		inventory_ui.inventory.add(items[index], 1)


func _remove(index: int) -> void:
	if index < items.size():
		inventory_ui.inventory.remove(items[index].type, 1)
