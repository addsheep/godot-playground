class_name Quest extends Resource

@export var id: String  ## unique ID
@export var short_description: String  ## under 10 words
@export var long_description: String  ## detailed description
@export var prerequisite: Array[Quest]  ## prerequisite quests must be finished before this quest is available
@export var target_amount: int  ## a generic integer target
@export var current_amount: int  ## the current amount
@export var started: bool  ## whether the quest has started


func is_completed() -> bool:
	return current_amount >= target_amount


func is_available() -> bool:
	for prereq: Quest in prerequisite:
		if !prereq.is_completed():
			return false
	return true
