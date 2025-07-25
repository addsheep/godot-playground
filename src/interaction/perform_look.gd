class_name PerformLook extends Node
## Shows a text popup with the given message when requested through perform().

@export var message: String = "a description of the object"

var interaction_controller: InteractionController

var _popup: Node


func perform() -> void:
	Toast.static_show(message, -1)
	if interaction_controller:
		interaction_controller.action_changed.emit(InteractionController.Action.LOOK, true)

	get_tree().create_timer(1).timeout.connect(
		func():
			if interaction_controller:
				interaction_controller.action_changed.emit(InteractionController.Action.LOOK, false)
	)


func _init() -> void:
	add_to_group("interaction_controller_consumer")
