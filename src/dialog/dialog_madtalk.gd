class_name Dialog extends Node

signal dialog_finished(sheet: String, sequence: int)

## Give items to the player. arg0: item type, arg1: amount
const CUSTOM_EFFECT_GIVE_ITEM := "effect_give_item"
## Take items from the player. arg0: item type, arg1: amount
const CUSTOM_EFFECT_TAKE_ITEM := "effect_take_item"
## Check amount of items. arg0: item type, arg1: amount
const CUSTOM_CONDITION_CHECK_ITEM := "check_item_has_at_least"

## Start a quest. arg0: quest id.
const CUSTOM_EFFECT_START_QUEST := "effect_start_quest"
## Check if a quest is available. arg0: quest id
const CUSTOM_CONDITION_CHECK_QUEST_AVAILABLE := "is_quest_available"
## Check if a quest has started. arg0: quest id
const CUSTOM_CONDITION_CHECK_QUEST_STARTED := "has_quest_started"
## Check if a quest has completed. arg0: quest id
const CUSTOM_CONDITION_CHECK_QUEST_COMPLETED := "is_quest_completed"

## The nodes to act on custom effects and check custom conditions.
## They should implement the methods specified in "callback_method_map".
## The first node providing the matching method will be called.
@export var custom_callback_nodes: Array[Node]
@export var callback_method_map: Dictionary = {
	CUSTOM_EFFECT_GIVE_ITEM: "add",
	CUSTOM_EFFECT_TAKE_ITEM: "remove",
	CUSTOM_CONDITION_CHECK_ITEM: "has_at_least",
	CUSTOM_EFFECT_START_QUEST: "start_quest",
	CUSTOM_CONDITION_CHECK_QUEST_AVAILABLE: "is_quest_available",
	CUSTOM_CONDITION_CHECK_QUEST_STARTED: "has_quest_started",
	CUSTOM_CONDITION_CHECK_QUEST_COMPLETED: "is_quest_completed"
}
@onready var _madtalk: Node = $"Madtalk"
@onready var _main: Control = %DialogMain

var _dialogs_started: Dictionary  # sheet: { sequence: $times_started }


func _ready() -> void:
	GlobalServiceRequests.start_dialog.connect(start)

	_main.gui_input.connect(_gui_input)
	_madtalk.dialog_started.connect(_on_dialog_started)
	_madtalk.dialog_finished.connect(_on_dialog_finished)

	# Do both since madtalk read the listener list only once, which makes it sensitive to the order of _ready
	_madtalk.custom_effect_callable = _on_custom_effect
	_madtalk.activate_custom_effect.connect(_on_custom_effect)

	_madtalk.evaluate_custom_condition.connect(_eval_custom_condition)
	_madtalk.custom_condition_callable = _eval_custom_condition


func _gui_input(event: InputEvent) -> void:
	if !MadTalkGlobals.is_during_dialog:
		return
	if event.is_action_pressed("left_click"):
		_madtalk.dialog_acknowledge()
		_main.accept_event()


func _unhandled_key_input(event: InputEvent) -> void:
	if !MadTalkGlobals.is_during_dialog:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		_madtalk.dialog_acknowledge()
		_main.accept_event()


func start(sheet: String, sequence: int = 0) -> void:
	_madtalk.start_dialog(sheet, sequence)


func get_started_times(sheet: String, sequence: int = 0) -> bool:
	return _dialogs_started.get(sheet, {}).get(sequence, 0)


func _on_dialog_started(sheet_name: String, sequence: int) -> void:
	var sequence_table: Dictionary = _dialogs_started.get_or_add(sheet_name, {})
	sequence_table[sequence] = sequence_table.get(sequence, 0) + 1


func _on_dialog_finished(sheet: String, sequence: int) -> void:
	await _main.visibility_changed
	dialog_finished.emit(sheet, sequence)


func _on_custom_effect(effect_id: String, args: Array) -> void:
	if !callback_method_map.has(effect_id):
		print_debug("Effect not implemented: %s" % effect_id)
	for callback_node in custom_callback_nodes:
		if callback_node.has_method(callback_method_map[effect_id]):
			callback_node.callv(callback_method_map[effect_id], args)
			return
	print_debug("Effect callback not found in any node: %s" % effect_id)


func _eval_custom_condition(condition_id: String, args: Array) -> bool:
	if !callback_method_map.has(condition_id):
		print_debug("Custom condition not found in map")
		return false
	for callback_node in custom_callback_nodes:
		if callback_node.has_method(callback_method_map[condition_id]):
			return callback_node.callv(callback_method_map[condition_id], args)

	print_debug("Custom condition not found in any node: %s" % condition_id)
	return false
