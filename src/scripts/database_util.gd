class_name DatabaseUtils extends Node

const db: Database = preload("res://assets/database.gddb")

static func load_res(path: String) -> Resource:
	return db.fetch_data_string(path)
