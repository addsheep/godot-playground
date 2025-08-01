extends Node
## This node is the bridge between global services and their clients.
## Clients emit events to be processed by the services.

## Execute a side effect, e.g. add items to inventory.
signal side_effect(side_effect: SideEffect)

## Show a toast message.
signal toast(msg: String, duration: float)

## Start a dialog.
signal start_dialog(sheet: String, sequence: int)

## Update/access quests.
signal start_quest(id: String)
signal increment_quest(id: String, delta: int)
signal get_active_quests(out: Array[Quest])

## Common service announcement
signal backpack_ready(inventory: Inventory)
signal quest_manager_ready(quest_manager: QuestManager)
