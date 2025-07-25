extends Node2D
## This node is responsible for loading/unloading scenes as a child with a fade transition.

const FADE_DURATION := 1.0

@export var current_world_name: String

var _current_world: Node


func _ready() -> void:
	if current_world_name:
		load_world(current_world_name)


func load_world(scene_name: String) -> void:
	var node: Node = DatabaseUtils.load_res("worlds/" + scene_name).instantiate()
	_play_transition(node)
	current_world_name = scene_name


func _play_transition(new_world: Node) -> void:
	var node := CanvasLayer.new()
	var color_rect := ColorRect.new()
	node.add_child(color_rect)
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.color = Color.TRANSPARENT
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(node)

	if _current_world:
		await (
			create_tween().tween_property(color_rect, "color", Color.BLACK, FADE_DURATION).finished
		)
		_current_world.queue_free()

	add_child(new_world)
	move_child(new_world, 0)
	_current_world = new_world

	await (
		create_tween()
		. tween_property(color_rect, "color", Color.TRANSPARENT, FADE_DURATION)
		. finished
	)
	node.queue_free()
