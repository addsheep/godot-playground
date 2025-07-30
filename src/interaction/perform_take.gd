extends Node

@export var item: Item
@export var object: CanvasItem


func perform() -> void:
	var side_effect := SideEffect.new()
	side_effect.type = SideEffect.Type.GOT_ITEM
	side_effect.args = [item.type, 1]
	GlobalServiceRequests.side_effect.emit(side_effect)

	var tween := create_tween()
	tween.tween_property(object, "modulate", Color.TRANSPARENT, .5)
	await tween.finished
	object.queue_free()
