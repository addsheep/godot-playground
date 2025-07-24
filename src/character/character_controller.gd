class_name CharacterController extends Node
## The controller integrates character activity, movement and animation.

@export var body: CharacterBody2D
@export var animation_controller: CharacterAnimationController
@export var looking: bool:
	set(v):
		if v != looking:
			looking = v
			if looking:
				animation_controller.state = CharacterAnimationController.State.LOOK
			else:
				_update_for_velocity()

## Injected by the global InteractionController to receive events
var interaction_controller: InteractionController:
	set(v):
		if interaction_controller:
			interaction_controller.disconnect("action_changed", _on_action_changed)
		interaction_controller = v
		interaction_controller.connect("action_changed", _on_action_changed)
		interaction_controller.player = body


func _init() -> void:
	add_to_group("interaction_controller_consumer")


func _physics_process(delta: float) -> void:
	_update_for_velocity()


func _update_for_velocity() -> void:
	if looking:
		return
	if body.velocity.length_squared() < 0.1:
		animation_controller.state = CharacterAnimationController.State.IDLE
	elif body.velocity.x < 0:
		animation_controller.state = CharacterAnimationController.State.WALK_LEFT
	else:
		animation_controller.state = CharacterAnimationController.State.WALK_RIGHT


func _on_action_changed(action: InteractionController.Action, active: bool):
	match action:
		InteractionController.Action.LOOK:
			looking = active
