extends Node

var _quest_table: Dictionary[String, Quest]  ## id -> Quest


func _enter_tree() -> void:
	var quests: Array = DatabaseUtils.load_collection("quests")
	for quest: Quest in quests:
		_quest_table[quest.id] = quest

	GlobalServiceRequests.start_quest.connect(start_quest)
	GlobalServiceRequests.increment_quest.connect(_increment_quest)
	GlobalServiceRequests.get_active_quests.connect(_get_active_quests)


func get_quest_by_id(id: String) -> Quest:
	return _quest_table.get(id)


func start_quest(id: String) -> void:
	if _quest_table.has(id) and _quest_table[id].is_available():
		_quest_table[id].started = true
	else:
		print_debug("Quest not found or unavailable")


func is_quest_available(id: String) -> bool:
	return _quest_table.has(id) and _quest_table[id].is_available()


func has_quest_started(id: String) -> bool:
	return _quest_table.has(id) and _quest_table[id].started


func is_quest_completed(id: String) -> bool:
	return _quest_table.has(id) and _quest_table[id].is_completed()


func _get_active_quests(out: Array[Quest]) -> void:
	out.clear()
	for quest: Quest in _quest_table.values():
		if quest.started:
			out.append(quest)


func _increment_quest(id: String, delta: int) -> void:
	if _quest_table.has(id) and _quest_table[id].started and !_quest_table[id].is_completed():
		_quest_table[id].current_amount += delta
