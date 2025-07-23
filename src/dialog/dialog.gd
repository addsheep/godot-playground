class_name Dialog extends Node

@onready var madtalk: Node = $"Madtalk"
@onready var main: Control = %DialogMain


func _ready() -> void:
	main.gui_input.connect(_gui_input)


func _gui_input(event: InputEvent) -> void:
	if !MadTalkGlobals.is_during_dialog:
		return
	if event.is_action_pressed("left_click"):
		madtalk.dialog_acknowledge()
		main.accept_event()


func _unhandled_key_input(event: InputEvent) -> void:
	if !MadTalkGlobals.is_during_dialog:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		madtalk.dialog_acknowledge()
		main.accept_event()
