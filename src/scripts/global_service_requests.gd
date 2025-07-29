extends Node
## This node is the bridge between global services and their clients.
## Clients emit events to be processed by the services.

signal side_effect(side_effect: SideEffect)

signal toast(msg: String, duration: float)
