class_name Dialog extends Node

signal dialog_finished(sheet: String, sequence: int)

@onready var _madtalk: Node = $"Madtalk"
@onready var _main: Control = %DialogMain

var _dialogs_started: Dictionary  # sheet: { sequence: $times_started }


func start(sheet: String, sequence: int = 0) -> void:
	_madtalk.start_dialog(sheet, sequence)


func get_started_times(sheet: String, sequence: int = 0) -> bool:
	return _dialogs_started.get(sheet, {}).get(sequence, 0)


func _ready() -> void:
	_main.gui_input.connect(_gui_input)
	_madtalk.dialog_started.connect(_on_dialog_started)
	_madtalk.dialog_finished.connect(dialog_finished.emit)


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


func _on_dialog_started(sheet_name: String, sequence: int) -> void:
	var sequence_table: Dictionary = _dialogs_started.get_or_add(sheet_name, {})
	sequence_table[sequence] = sequence_table.get(sequence, 0) + 1
