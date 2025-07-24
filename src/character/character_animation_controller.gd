@tool
class_name CharacterAnimationController extends Node
## A controller for character animation that manages transition between idle/walk/look/... states.
## It searches for named animations from the given AnimatedSprite2D.
## The animation names can be customized through the "animation_names" dictionary.

enum State { IDLE, WALK_LEFT, WALK_RIGHT, LOOK }

@export var animated_sprite: AnimatedSprite2D  ## required
@export var animation_names: Dictionary = {"walk": "walk", "idle": "idle", "look": "look"}
@export var state: State = State.IDLE:
	set(v):
		if v != state:
			state = v
			_update_state()


func _get_configuration_warnings() -> PackedStringArray:
	if !animated_sprite:
		return ["animated_sprite must be set"]

	for animation_name in animation_names.values():
		if !animated_sprite.sprite_frames.has_animation(animation_name):
			return ["Animation %s is not found" % animation_name]
	return []


func _play_animation(anim_name: String) -> void:
	if animated_sprite.animation == anim_name:
		return
	if animated_sprite.is_playing():
		animated_sprite.stop()
	if animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)


func _update_state() -> void:
	match state:
		State.IDLE:
			_play_animation(animation_names["idle"])
		State.WALK_LEFT, State.WALK_RIGHT:
			_play_animation(animation_names["walk"])
			animated_sprite.flip_h = state == State.WALK_LEFT
		State.LOOK:
			_play_animation(animation_names["look"])
