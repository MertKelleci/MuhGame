extends PlayerState

func _on_moving_state_physics_processing(delta: float) -> void:
	if player_controller and player_controller._input_dir.length() == 0:
		player_controller.state_chart.send_event("onIdle") # Replace with function body.
