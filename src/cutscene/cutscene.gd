extends Node

@export var animation_player: AnimationPlayer
@export var animation_name: String = "default"


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true

	animation_player.play(animation_name)
	animation_player.animation_finished.connect(_end_cutscene)


func _end_cutscene(_name) -> void:
	get_tree().paused = false
	queue_free()
