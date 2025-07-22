class_name InventoryUI extends Node

signal item_gui_input(event: InputEvent, item: Item)

@export var inventory: Inventory
@export var icon_path: String = "Icon"  # path of the item icon relative to the cell
@export var amount_path: String = "Label"  # path of the amount label relative to the cell

@onready var _cell_template: Control = %Cell

var _item_cell_map: Dictionary  # type -> cell


func _ready() -> void:
	_cell_template.hide()
	_load_all()
	inventory.slot_changed.connect(_on_inventory_changed)


func _load_all() -> void:
	var slots: Dictionary = inventory.get_all()
	for slot: Inventory.Slot in slots.values():
		if slot.amount > 0:
			_add_cell(slot.item, slot.amount)


func _add_cell(item: Item, amount: int) -> void:
	var cell: Control = _cell_template.duplicate()
	var icon: TextureRect = cell.get_node(icon_path)
	icon.texture = item.icon
	cell.tooltip_text = item.display_name
	var label: Label = cell.get_node(amount_path) as Label
	label.text = "%d" % amount

	add_child(cell)
	cell.show()
	_item_cell_map[item.type] = cell

	cell.gui_input.connect(item_gui_input.emit.bind(item))


func _remove_cell(item: Item) -> void:
	var cell: Control = _item_cell_map.get(item.type)
	if cell:
		cell.queue_free()
		_item_cell_map.erase(item.type)


func _on_inventory_changed(item: Item, old_amount: int, new_amount: int) -> void:
	if new_amount == 0:
		_remove_cell(item)
		return

	var cell: Control = _item_cell_map.get(item.type)
	if cell == null:
		_add_cell(item, new_amount)
	else:
		(cell.get_node(amount_path) as Label).text = "%d" % new_amount
