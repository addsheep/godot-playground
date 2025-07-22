class_name PerformLook extends Node

const POPUP_PATH := "PackedScenes/text_popup"

@export var description: String = "a description of the object"

var _popup: Node


func perform() -> void:
	if _popup:
		return
	_popup = DatabaseUtils.load_res(POPUP_PATH).instantiate()
	add_child(_popup)
	var label: Label = _popup.get_node("%Label")
	label.text = description


func _unhandled_input(event: InputEvent) -> void:
	if _popup and event.is_action_pressed("left_click"):
		_popup.queue_free()
		_popup = null
		get_viewport().set_input_as_handled()
