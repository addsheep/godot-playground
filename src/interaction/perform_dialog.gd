extends Node

## The dialog sheet id
@export var timeline: DialogicTimeline


func perform() -> void:
	Dialogic.start(timeline)
