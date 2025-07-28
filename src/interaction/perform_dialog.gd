extends Node

## The dialog sheet id
@export var madtalk_sheet_id: String = ""
@export var dialog: Dialog


func perform() -> void:
	dialog.start(madtalk_sheet_id)
