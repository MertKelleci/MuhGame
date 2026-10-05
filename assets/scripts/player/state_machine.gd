class_name PlayerStateMachine extends Node
@export var debug : bool = false
@export_category("References")
@export var player_controller : PlayerController

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_controller:
		player_controller.state_chart.set_expression_property("Looking", player_controller.interaction_raycast.current_object)
