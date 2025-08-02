extends Node

@export var item_type: String
@export var quest_id: String

var _inventory: Inventory
var _quest_manager: QuestManager


func _init() -> void:
	GlobalServiceRequests.backpack_ready.connect(func(inv): _inventory = inv)
	GlobalServiceRequests.quest_manager_ready.connect(func(qm): _quest_manager = qm)


func start_quest():
	if _quest_manager:
		if (
			_quest_manager.has_quest_started(quest_id)
			or !_quest_manager.is_quest_available(quest_id)
		):
			return
		_quest_manager.start_quest(quest_id)
		if _inventory:
			_inventory.slot_changed.connect(_on_inventory_changed)
		else:
			print_debug("Inventory is null")
	else:
		print_debug("Quest manager is null")


func _on_inventory_changed(item: Item, old: int, new: int) -> void:
	if item.type == item_type:
		_quest_manager.increment_quest(quest_id, new - old)
