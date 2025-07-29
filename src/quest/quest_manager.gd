extends Node

var _quest_table: Dictionary[String, Quest]  ## id -> Quest


func _enter_tree() -> void:
	# todo: load quests

	GlobalServiceRequests.start_quest.connect(_start_quest)
	GlobalServiceRequests.increment_quest.connect(_increment_quest)


func get_quest_by_id(id: String) -> Quest:
	return _quest_table.get(id)


func _start_quest(id: String) -> void:
	if _quest_table.has(id):
		_quest_table[id].started = true


func _increment_quest(id: String) -> void:
	if _quest_table.has(id) and _quest_table[id].started:
		_quest_table[id].current_amount += 1
