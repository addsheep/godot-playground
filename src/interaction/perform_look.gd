class_name PerformLook extends Node
## Shows a text popup with the given message when requested through perform().

@export var message: String = "a description of the object"
@export var side_effect: SideEffect
@export var repeat_side_effect: bool

var interaction_controller: InteractionController

var _popup: Node
var _side_effect_visited: bool


func perform() -> void:
	if interaction_controller:
		interaction_controller.action_changed.emit(InteractionController.Action.LOOK, true)

	get_tree().create_timer(1).timeout.connect(
		func():
			if interaction_controller:
				interaction_controller.action_changed.emit(InteractionController.Action.LOOK, false)
	)
	var side_effect_text: String
	if side_effect:
		if !_side_effect_visited or repeat_side_effect:
			GlobalEvents.side_effect_requested.emit(side_effect)
			side_effect_text = side_effect.get_rich_text()
		_side_effect_visited = true

	Toast.static_show(message + "\n" + side_effect_text, -1)


func _init() -> void:
	add_to_group("interaction_controller_consumer")
