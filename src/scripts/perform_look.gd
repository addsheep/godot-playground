class_name PerformLook extends Node

const POPUP_PATH := "PackedScenes/text_popup"

@export var message: String = "a description of the object"

var _popup: Node


func perform() -> void:
	if !_popup:
		_popup = DatabaseUtils.load_res(POPUP_PATH).instantiate()
		add_child(_popup)
	var label: RichTextLabel = _popup.get_node("%Label")
	label.text = message
	_popup.show()


func _input(event: InputEvent) -> void:
	if _popup and event.is_action_pressed("left_click"):
		_popup.hide()
