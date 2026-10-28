@tool
extends StaticBody3D

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	get_node("HealthComponent").max_health = entity_properties["max_health"] as float

func _on_health_component_died() -> void:
	queue_free()
