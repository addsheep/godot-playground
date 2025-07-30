extends Node

@export var example_quest: Quest
@export var inventory: Inventory

var _item: Item


func _ready() -> void:
	_item = Item.new()
	_item.type = "3984"


func start_quest() -> void:
	GlobalServiceRequests.start_quest.emit(example_quest.id)
	inventory.slot_changed.connect(_on_inventory_changed)


func add_inventory() -> void:
	inventory.add(_item)


func _on_inventory_changed(item: Item, old: int, new: int) -> void:
	if item.type == _item.type:
		GlobalServiceRequests.increment_quest.emit(example_quest.id, new - old)
