extends Node
## This node is the bridge between global services and their clients.
## Clients emit events to be processed by the services.

## Execute a side effect, e.g. add items to inventory.
signal side_effect(side_effect: SideEffect)

## Show a toast message.
signal toast(msg: String, duration: float)

## Update/access quests.
signal start_quest(id: String)
signal increment_quest(id: String, delta: int)
signal get_active_quests(out: Array[Quest])
