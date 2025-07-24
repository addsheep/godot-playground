class_name CharacterController extends Node

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
