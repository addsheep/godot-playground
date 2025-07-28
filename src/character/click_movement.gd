extends Node
## Click based 2D movement.

@export var body: CharacterBody2D  ## the body is moved to the mouse click
@export var speed: float = 100  ## in pixel/s
@export var anchor: Node2D  ## optional, flashed at where is clicked

@export var velocity: Vector2:
	get:
		return body.velocity

var _target: Vector2  # current target position (global coord)
var _auto_fade_anchor: AutoFade
var _anchor_tween: Tween


func _ready() -> void:
	_target = body.global_position
	if anchor:
		anchor.modulate.a = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		body.velocity = Vector2.ZERO
		_target = body.global_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		_target = body.get_global_mouse_position()
		get_viewport().set_input_as_handled()
		_show_anchor()


func _physics_process(delta: float) -> void:
	if body.global_position.distance_to(_target) > 1:
		body.velocity = speed * body.global_position.direction_to(_target)
		body.move_and_slide()
	else:
		body.velocity = Vector2.ZERO


func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		_target = body.global_position


func _show_anchor() -> void:
	if anchor:
		anchor.global_position = _target
		if _anchor_tween:
			_anchor_tween.kill()
		_anchor_tween = create_tween()
		var rgb: Color = anchor.modulate
		_anchor_tween.tween_property(anchor, "modulate", Color(rgb.r, rgb.g, rgb.b, 1), 0.2)
		_anchor_tween.tween_property(anchor, "modulate", Color(rgb.r, rgb.g, rgb.b, 0), 0.4)
		await _anchor_tween.finished
		_anchor_tween = null
