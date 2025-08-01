extends Node

@export var timeline: DialogicTimeline


func _ready() -> void:
	Dialogic.start(timeline)
