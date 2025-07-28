class_name SideEffectHandler extends Node

@export var backpack: Backpack


func _enter_tree() -> void:
	GlobalEvents.side_effect_requested.connect(_process_side_effect)


func _process_side_effect(side_effect: SideEffect) -> void:
	match side_effect.type:
		SideEffect.Type.GOT_ITEM:
			if backpack:
				backpack.add_str(side_effect.args)
			else:
				print_debug("Cannot process side effect due to null backpack")
