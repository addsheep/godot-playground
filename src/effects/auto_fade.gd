class_name AutoFade extends CanvasItem
## Call show/hide on this node will fade-in/fade-out the target node.

@export var effect_target: CanvasItem
@export var delay: float = 0.5
@export var start_hidden: bool

var saved_modulate: Color
var tween: Tween


func _ready() -> void:
	saved_modulate = effect_target.modulate
	if start_hidden:
		effect_target.hide()
	visible = effect_target.visible

	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if tween and tween.is_running():
		tween.kill()
	if is_visible_in_tree():
		effect_target.modulate.a = 0
		effect_target.visible = true
		tween = create_tween()
		await tween.tween_property(effect_target, "modulate", saved_modulate, delay)
	else:
		var final: Color = Color(saved_modulate.r, saved_modulate.g, saved_modulate.b, 0)
		tween = create_tween()
		await tween.tween_property(effect_target, "modulate", final, delay).finished
		effect_target.visible = false
