extends Control

@export var list_container: Control
@export var row_prefab: PackedScene

var _ui_map: Dictionary[Quest, Control]
var _active_quests: Array[Quest]


func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 1
	timer.one_shot = false
	timer.timeout.connect(_sync_ui)
	add_child(timer)
	timer.start()


func _sync_ui() -> void:
	GlobalServiceRequests.get_active_quests.emit(_active_quests)
	for quest: Quest in _active_quests:
		if _ui_map.has(quest):
			_update_quest_state(quest)
		else:
			_add_quest(quest)


func _add_quest(quest: Quest) -> void:
	var row: Control = row_prefab.instantiate()
	list_container.add_child(row)
	_ui_map[quest] = row
	_update_quest_state(quest)


func _update_quest_state(quest: Quest) -> void:
	var row: Control = _ui_map[quest]
	(row.get_node("CheckBox") as CheckBox).button_pressed = quest.is_completed()
	var label: RichTextLabel = row.get_node("RichTextLabel")
	label.text = "%s [%d/%d]" % [quest.short_description, quest.current_amount, quest.target_amount]
