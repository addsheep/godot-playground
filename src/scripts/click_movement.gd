extends Node
## Click based 2D movement.

@export var body: CharacterBody2D
@export var speed: float = 100
@export var func_is_allowed: Callable  # called before handling input

@export var velocity: Vector2:
	get:
		return body.velocity

var _target: Vector2  # current target position (global coord)


func _ready() -> void:
	_target = body.global_position


func _unhandled_input(event: InputEvent) -> void:
	if func_is_allowed and !func_is_allowed.call():
		return
	if event.is_action_pressed("left_click"):
		_target = body.get_global_mouse_position()
		get_viewport().set_input_as_handled()


func _physics_process(delta: float) -> void:
	if func_is_allowed and !func_is_allowed.call():
		return
	if body.global_position.distance_to(_target) > 1:
		body.velocity = speed * body.global_position.direction_to(_target)
		body.move_and_slide()
	else:
		body.velocity = Vector2.ZERO
