extends PlayerState
var has_jumped : bool = false

func _on_jumping_state_entered() -> void:
	player_controller.jump()
	has_jumped = true


func _on_jumping_state_physics_processing(delta: float) -> void:
	if player_controller.is_on_floor() and has_jumped:
		player_controller.state_chart.send_event("onGrounded")
		has_jumped = false
