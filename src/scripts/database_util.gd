class_name DatabaseUtils extends Node

const db: Database = preload("res://assets/database.gddb")


## Load a resource by its DB path "[collection]/[string_id]"
static func load_res(path: String) -> Resource:
	return db.fetch_data_string(path)
