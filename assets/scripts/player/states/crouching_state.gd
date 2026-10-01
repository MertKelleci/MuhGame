extends PlayerState

func _on_crouching_state_physics_processing(delta: float) -> void:
	if not Input.is_action_pressed("crouch") and player_controller.is_on_floor():
		player_controller.state_chart.send_event("onStanding")


func _on_crouching_state_entered() -> void:
	player_controller.is_crouching(true)


func _on_crouching_state_exited() -> void:
	player_controller.is_crouching(false)
