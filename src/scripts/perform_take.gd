extends Node

@export var item: Item
@export var inventory: Inventory
@export var animation_player: AnimationPlayer  # play object taken animation


func perform() -> void:
	inventory.add(item)
	animation_player.play("taken")
