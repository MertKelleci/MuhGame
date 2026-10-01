class_name PlayerStateMachine extends Node
@export var debug : bool = false
@export_category("References")
@export var player_controller : PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if player_controller:
		#player_controller.state_chart.set_expression_property("Text", Value)
