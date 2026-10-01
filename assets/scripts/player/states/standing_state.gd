extends PlayerState

func _on_standing_state_physics_processing(delta: float) -> void:
	if Input.is_action_pressed("crouch") and player_controller.is_on_floor():
		player_controller.state_chart.send_event("onCrouching")
