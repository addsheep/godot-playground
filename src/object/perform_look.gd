class_name PerformLook extends Node
## Shows a text popup with the given message when requested through perform().

const POPUP_PATH := "PackedScenes/text_popup"

@export var message: String = "a description of the object"

var interaction_controller: InteractionController

var _popup: Node


func perform() -> void:
	if !_popup:
		_popup = DatabaseUtils.load_res(POPUP_PATH).instantiate()
		add_child(_popup)
	var label: RichTextLabel = _popup.get_node("%Label")
	label.text = message

	if interaction_controller:
		interaction_controller.action_changed.emit(InteractionController.Action.LOOK, true)
	_popup.show()


func _init() -> void:
	add_to_group("interaction_controller_consumer")


func _input(event: InputEvent) -> void:
	if _popup and event.is_action_pressed("left_click"):
		_popup.hide()
		if interaction_controller:
			interaction_controller.action_changed.emit(InteractionController.Action.LOOK, false)
