class_name SideEffect extends Resource

enum Type { GOT_ITEM }

@export var type: Type
@export var args: Array


func get_rich_text() -> String:
	match type:
		Type.GOT_ITEM:
			var item: Item = Item.item_from_type(args[0])
			return "[img]%s[/img]X%s" % [item.icon.resource_path, args[1]]
	return ""
