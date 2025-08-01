extends Node
## This node is the bridge between common services and their clients.

## Execute a side effect, e.g. add items to inventory. SideEffectHandler listens to them.
signal side_effect(side_effect: SideEffect)

## Show a toast message.
signal toast(msg: String, duration: float)

## Requests to update/access quests. QuestManager processes them.
signal start_quest(id: String)
signal increment_quest(id: String, delta: int)
signal get_active_quests(out: Array[Quest])

## Common service announcement if the client needs to cache a reference.
signal backpack_ready(inventory: Inventory)
signal quest_manager_ready(quest_manager: QuestManager)
