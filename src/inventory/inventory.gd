class_name Inventory extends Resource

const INVENTORY_PATH := "user://inventory.tres"

# Emitted when a slot changes
signal slot_changed(item: Item, old_amount: int, new_amount: int)


class Slot:
	var item: Item
	var amount: int

	func _init(im: Item, at: int = 0) -> void:
		item = im
		amount = at


@export var _slots := {}  # type -> Slot


## Load the [Inventory] from file or create a new resource, if it was missing. Godot caches calls,
## so this can be used every time needed.
static func restore() -> Inventory:
	if Engine.is_editor_hint():
		return null

	if FileAccess.file_exists(INVENTORY_PATH):
		var inventory = ResourceLoader.load(INVENTORY_PATH) as Inventory
		if inventory:
			return inventory

	# Either there is no inventory associated with this profile or the file itself could not be
	# loaded. Either way, a new inventory resource must be created.
	var new_inventory := Inventory.new()
	new_inventory.save()
	return new_inventory


## Increment the count of a given item by one, adding it to the inventory if it does not exist.
func add(item: Item, amount := 1) -> void:
	# Note that adding negative numbers is possible. Prevent having a total of negative items.
	# NPC: "You cannot have negative potatoes."
	var slot: Slot = _slots.get_or_add(item.type, Slot.new(item))
	var old_amount := slot.amount
	var new_amount = maxi(old_amount + amount, 0)
	slot.amount = new_amount

	slot_changed.emit(item, old_amount, new_amount)
	print_debug("Item added to inventory: %s, %d" % [item.display_name, amount])


## Decrement the count of a given item by one.
## The item will be removed entirely if there are none remaining. Removing an item that is not
## posessed will do nothing.
func remove(item_type: String, amount := 1) -> void:
	var slot: Slot = _slots.get(item_type)
	if slot == null:
		return
	add(slot.item, -amount)


## Returns the number of a certain item type posessed by the player.
func get_item_count(item_type: String) -> int:
	return _slots.get(item_type, Slot.new(null)).amount


## Returns the Item associated with a given item type.
func get_item_data(type: String) -> Item:
	var slot: Slot = _slots.get(type, Slot.new(null))
	return slot.item


## Returns all slots.
func get_all() -> Dictionary:
	return _slots


## Write the inventory contents to the disk.
func save() -> void:
	ResourceSaver.save(self, INVENTORY_PATH)
