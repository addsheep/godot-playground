class_name Toast extends Node

@export var duration: float = 1.0

@onready var _toast_ui: CanvasItem = %AutoFade
@onready var _label: Label = %Label

var msg_queue: Array[String]


func show(msg: String) -> void:
	if !_toast_ui.visible:
		_internal_show(msg)
	else:
		msg_queue.append(msg)


func _unhandled_input(event: InputEvent) -> void:
	if _toast_ui.visible and event.is_action_pressed("left_click"):
		_toast_ui.hide()
		get_viewport().set_input_as_handled()
		_process_queue()


func _internal_show(msg: String) -> void:
	_label.text = msg
	_toast_ui.show()
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		_toast_ui.hide()
		_process_queue()


func _process_queue() -> void:
	if msg_queue.size():
		_internal_show(msg_queue.pop_front())
