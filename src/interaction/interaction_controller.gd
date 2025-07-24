class_name InteractionController extends Node
## This class facilitates the interaction between player and interactable objects.
## It finds all nodes in the group "interaction_controller_consumer" and injects itself to the consumer.

enum Action { LOOK, TALK, TAKE }

signal action_changed(action: Action, active: bool)

var player: Node2D


func _ready() -> void:
	var nodes := get_tree().get_nodes_in_group("interaction_controller_consumer")
	for node: Node in nodes:
		node.set("interaction_controller", self)
