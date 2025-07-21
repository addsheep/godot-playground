class_name Dialog extends Node

@onready var madtalk: Node = $"Madtalk"

func _ready() -> void:
	%"DialogMain".hide()

func _input(event: InputEvent) -> void:
	if !MadTalkGlobals.is_during_dialog:
		return
	if event.is_action_pressed("left_click"):
		madtalk.dialog_acknowledge()
		# Do not call get_viewport().set_input_as_handled() due to blocking button press

func _unhandled_key_input(event: InputEvent) -> void:
	if !MadTalkGlobals.is_during_dialog:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		madtalk.dialog_acknowledge()
		get_viewport().set_input_as_handled()
