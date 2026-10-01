extends PlayerState

func _on_running_state_entered() -> void:
	player_controller.is_running(true) # Replace with function body.


func _on_running_state_exited() -> void:
	player_controller.is_running(false) # Replace with function body.


func _on_running_state_physics_processing(delta: float) -> void:
	if not Input.is_action_pressed("sprint"):
		player_controller.state_chart.send_event("onWalking")# Replace with function body.
