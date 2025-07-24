extends Node


func _ready() -> void:
	var node: Dialog = $"Dialog"
	node.start("test_dialog_0")
	node.dialog_finished.connect(func(sheet, sequence): print_debug("dialog finished: %s" % sheet))
