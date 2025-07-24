extends Control

## A clickable object that shows an interaction menu on click.
## - add/remove children of "Interactions". Each child node should have a "perform" method.

@export var range: float = 50  ## clickable when the player is within this range

var interaction_controller: InteractionController

var _interaction_nodes: Array[Node]

@onready var _menu: Control = $AutoFadeMenu


func _init() -> void:
	add_to_group("interaction_controller_consumer")


func _ready() -> void:
	_interaction_nodes = get_node("Interactions").get_children()
	_menu.z_index = 1000
	_menu.hide()
	_build_menu()


## Close menu on click anywhere
func _input(event: InputEvent) -> void:
	if _menu.visible and event.is_action_pressed("left_click"):
		_menu.hide()


## Show menu on click
func _gui_input(event: InputEvent) -> void:
	if (
		interaction_controller
		and global_position.distance_to(interaction_controller.get_player_position()) > range
	):
		return
	if event.is_action_pressed("left_click"):
		_menu.show()
		accept_event()


## Internal methods


func _perform_action(interaction: Node) -> void:
	if interaction.has_method("perform"):
		interaction.perform()
	_menu.hide()


func _build_menu() -> void:
	var menu := get_node("Menu")
	var template_button: Button = menu.get_child(0)
	for child in menu.get_children():
		child.queue_free()

	for interaction in _interaction_nodes:
		var button: Button = template_button.duplicate()
		button.text = interaction.name
		button.pressed.connect(_perform_action.bind(interaction))
		menu.add_child(button)
