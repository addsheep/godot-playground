extends Node

const POPUP: PackedScene = preload("uid://ua0ghmjaouf")  # text_popup

@export var description: String = "a description of the object"

var _popup: Node


func perform() -> void:
	_popup = POPUP.instantiate()
	get_tree().root.add_child(_popup)
	var label: Label = _popup.get_node("%Label")
	label.text = description


func _unhandled_input(event: InputEvent) -> void:
	if _popup and event.is_action_pressed("left_click"):
		_popup.queue_free()
		get_viewport().set_input_as_handled()
