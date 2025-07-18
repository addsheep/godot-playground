extends Node

const POPUP: PackedScene = preload("uid://ua0ghmjaouf")  # text_popup.tscn

@export var description: String = "a description of the object"
@export var animation_tree: AnimationTree  # Allow setting condition "looking" to trigger the animation

var _popup: Node


func perform() -> void:
	if animation_tree:
		animation_tree.set("parameters/conditions/looking", true)
		await animation_tree.animation_finished
		animation_tree.set("parameters/conditions/looking", false)

	_popup = POPUP.instantiate()
	get_tree().root.add_child(_popup)
	var label: Label = _popup.get_node("%Label")
	label.text = description


func _unhandled_input(event: InputEvent) -> void:
	if _popup and event.is_action_pressed("left_click"):
		_popup.queue_free()
		_popup = null
		get_viewport().set_input_as_handled()
