extends Node

## Find all tests in the folder and creates a button for each.

@onready var _button_container: Control = %ButtonContainer


func _ready():
	var script_path = get_script().get_path()
	var script_dir = script_path.get_base_dir()

	var dir = DirAccess.open(script_dir)
	if not dir:
		push_error("Failed to access directory: " + script_dir)
		return []

	var current_scene_file := get_tree().current_scene.scene_file_path.get_file()
	for filename in dir.get_files():
		if filename.get_extension() == "tscn" and filename.begins_with("test_"):
			var button := Button.new()
			button.text = filename.get_basename()
			button.pressed.connect(_start_test.bind(script_dir.path_join(filename)))
			_button_container.add_child(button)


func _start_test(test_path: String) -> void:
	var node: Node = load(test_path).instantiate()
	get_parent().add_child(node)
	queue_free()
