extends WeaponState
@onready var state_chart_debugger: Control = %StateChartDebugger

func _on_empty_state_state_entered() -> void:
	state_chart_debugger.add_history_entry("Weapon empty")


func _on_empty_state_state_processing(delta: float) -> void:
	pass # Replace with function body.
