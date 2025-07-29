class_name Toast extends Node

@export var default_duration: float = 1.0

@onready var _toast_ui: CanvasItem = %AutoFade
@onready var _label: RichTextLabel = %Label

var _msg_queue: Array  ## [[msg, duration]]
var _current_duration: float = -1


func _ready() -> void:
	GlobalServiceRequests.toast.connect(show)


func _input(event: InputEvent) -> void:
	if _toast_ui.visible and _current_duration < 0 and event.is_action_pressed("left_click"):
		_toast_ui.hide()
		get_viewport().set_input_as_handled()
		_process_queue()


func show(msg: String, duration: float = default_duration) -> void:
	if !_toast_ui.visible:
		_internal_show(msg, duration)
	else:
		_msg_queue.append([msg, duration])


func _internal_show(msg: String, duration: float) -> void:
	_label.text = msg
	_toast_ui.show()
	_current_duration = duration
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		_toast_ui.hide()
		_process_queue()


func _process_queue() -> void:
	if _msg_queue.size():
		var row: Array = _msg_queue.pop_front()
		_internal_show(row[0], row[1])
