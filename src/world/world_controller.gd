extends Node2D
## This node is responsible for loading/unloading scenes as a child.

@export var current_world_name: String

var _current_world: Node


func _ready() -> void:
	if current_world_name:
		load_world(current_world_name)


func load_world(scene_name: String) -> void:
	var node: Node = DatabaseUtils.load_res("worlds/" + scene_name).instantiate()
	if _current_world:
		_current_world.queue_free()
	add_child(node)
	_current_world = node
	current_world_name = scene_name
