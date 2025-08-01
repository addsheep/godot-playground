@tool
class_name CutScene extends Node

@export var animation_player: AnimationPlayer
@export var animation_name: String = "default"
@export var auto_end: bool
@export var dialog_timeline: DialogicTimeline


func _get_configuration_warnings() -> PackedStringArray:
	if animation_player == null:
		return ["animation_player cannot be null"]
	if !animation_player.has_animation(animation_name):
		return ["%s doesn't exist" % animation_name]
	return []


func _ready() -> void:
	if not Engine.is_editor_hint():
		process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		get_tree().paused = true

		animation_player.play(animation_name)
		if auto_end:
			animation_player.animation_finished.connect(func(_name): end_cutscene())


func end_cutscene() -> void:
	get_tree().paused = false
	queue_free()


func start_dialog() -> void:
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.Styles.load_style("", self)  ## load the style nodes under the cutscene node for enabled processing
	Dialogic.timeline_ended.connect(end_cutscene)
	Dialogic.start(dialog_timeline)
