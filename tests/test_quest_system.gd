extends Node

@export var example_quest: Quest
@export var dialog_timeline: DialogicTimeline

@onready var backpack: Backpack = $Backpack


func start_dialog() -> void:
	Dialogic.start(dialog_timeline)


func add_inventory() -> void:
	backpack.inventory.add(Item.item_from_type("test_item"), 1)
