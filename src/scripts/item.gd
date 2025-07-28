class_name Item extends Resource

const DB_PATH_PREFIX := "items/"

@export var type: String  # items of the same type are stacked in one slot of inventory
@export var display_name: String
@export var description: String
@export var icon: CompressedTexture2D


static func icon_from_type(type: String) -> CompressedTexture2D:
	var item: Item = item_from_type(type)
	if item:
		return item.icon
	return null


static func item_from_type(type: String) -> Item:
	return DatabaseUtils.load_res(DB_PATH_PREFIX + type)
