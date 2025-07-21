class_name PerformLook extends Node

const POPUP_PATH := "PackedScenes/text_popup"

@export var description: String = "a description of the object"
@export var animation_tree: AnimationTree  # AnimationTree checks condition "looking" to trigger the animation

var _popup: Node


func perform() -> void:
	if animation_tree:
		animation_tree.set("parameters/conditions/looking", true)
		await get_tree().create_timer(0.5).timeout
		animation_tree.set("parameters/conditions/looking", false)

	_popup = DatabaseUtils.load_res(POPUP_PATH).instantiate()
	add_child(_popup)
	var label: Label = _popup.get_node("%Label")
	label.text = description


func _unhandled_input(event: InputEvent) -> void:
	if _popup and event.is_action_pressed("left_click"):
		_popup.queue_free()
		_popup = null
		get_viewport().set_input_as_handled()
