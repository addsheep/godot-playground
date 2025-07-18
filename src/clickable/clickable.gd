extends Area2D

## A clickable object that shows an interaction menu on click.
## How to customize:
## - add/remove children of "Interactions". Each child node should have a "perform" method.
## - make a unique shape for CollisionShape2D

var _interaction_nodes: Array[Node]

@onready var _gui: Control = $GUI
@onready var _menu: Control = $GUI/Menu

## Node overrides


func _ready() -> void:
	_interaction_nodes = get_node("Interactions").get_children()
	_gui.z_index = 1000
	_menu.hide()
	_build_menu()


func _unhandled_input(event: InputEvent) -> void:
	if _menu.visible and event.is_action_pressed("left_click"):
		_menu.hide()
		get_viewport().set_input_as_handled()


## Area2D overrides


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		_menu.show()
		get_viewport().set_input_as_handled()


func _mouse_enter() -> void:
	print_debug("mouse enter")
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _mouse_exit() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


## Internal methods


func _perform_action(interaction: Node) -> void:
	# TODO: how to wait for movement/animation?
	if interaction.has_method("perform"):
		interaction.perform()
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
