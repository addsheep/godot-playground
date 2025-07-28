extends Node2D

@export var packed_cutscene: PackedScene
@export var trigger_once: bool = true

@onready var _area: Area2D = $Area2D

var _visited: bool


func _ready() -> void:
	_area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if _visited and trigger_once:
		return
	_visited = true
	add_child(packed_cutscene.instantiate())
