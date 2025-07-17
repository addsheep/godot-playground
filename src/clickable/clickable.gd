extends Area2D

## A clickable object that shows an interaction menu on click.
## How to customize:
## - add a visual node under "Visual"
## - set "display_name"
## - add/remove children of "Interactions".
## - make a unique shape for CollisionShape2D
## - adjust GUI/Menu size and position

@export var display_name: String

var _interaction_nodes: Array[Node]

@onready var _gui := $GUI
@onready var _menu := $GUI/Menu

## Built-in overrides


func _ready() -> void:
	_interaction_nodes = get_node("Interactions").get_children()
	_gui.z_index = 1000
	_menu.hide()
	_build_menu()


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		_menu.show()


## Internal methods


func _perform_action(interaction: Node) -> void:
	if interaction.has_method("perform"):
		interaction.perform()
	_menu.hide()


func _unhandled_input(event: InputEvent) -> void:
	if (
		_menu.visible
		and event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		_menu.hide()


func _build_menu() -> void:
	var menu := get_node("GUI/Menu")
	var template_button: Button = menu.get_child(0)
	for child in menu.get_children():
		child.queue_free()

	for interaction in _interaction_nodes:
		var button: Button = template_button.duplicate()
		button.text = interaction.name
		button.pressed.connect(_perform_action.bind(interaction))
		menu.add_child(button)
