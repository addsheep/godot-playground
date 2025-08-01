extends Node
## The Autoload node to handle Dialogic calls.

var _inventory: Inventory
var _quest_manager: QuestManager


func _ready() -> void:
	GlobalServiceRequests.backpack_ready.connect(func(inv): _inventory = inv)
	GlobalServiceRequests.quest_manager_ready.connect(func(qm): _quest_manager = qm)


#region Inventory related APIs
func has_items(type: String, amount: int) -> bool:
	if _inventory:
		return _inventory.get_item_count(type) >= amount
	return false


func add_item(type: String, amount: int) -> void:
	if _inventory:
		var item := Item.item_from_type(type)
		if item:
			_inventory.add(item, amount)


#endregion


#region Quest related APIs
func is_quest_started(id: String) -> bool:
	if _quest_manager:
		return _quest_manager.has_quest_started(id)
	return false


func is_quest_available(id: String) -> bool:
	if _quest_manager:
		return _quest_manager.is_quest_available(id)
	return false


func is_quest_completed(id: String) -> bool:
	if _quest_manager:
		return _quest_manager.is_quest_completed(id)
	return false


func start_quest(id: String) -> void:
	if _quest_manager:
		_quest_manager.start_quest(id)


func update_quest(id: String, delta: int) -> void:
	if _quest_manager:
		_quest_manager.increment_quest(id, delta)
#endregion
