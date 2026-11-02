@tool
class_name TriggerVolume extends Area3D

@export var targets: Array[String] = []
enum trigger_amounts {SINGLE, MULTIPLE}
@export var trigger_amount := trigger_amounts.SINGLE
enum trigger_types {ON_EXIT, ON_ENTER, ON_ENTER_EXIT}
@export var trigger_type := trigger_types.ON_ENTER
@export var delay: float = 0.0

var has_triggered := false

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	var target_string = entity_properties.get("target", "") as String
	if target_string != "":
		var split_targets = target_string.split(",", false)
		targets.clear()
		for target in split_targets:
			targets.append(target.strip_edges())
			
	trigger_amount = entity_properties.get("trigger_amount", trigger_amounts.SINGLE) as trigger_amounts
	trigger_type = entity_properties.get("trigger_type", trigger_types.ON_ENTER) as trigger_types
	delay = entity_properties.get("delay", 0.0) as float
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if trigger_amount == trigger_amounts.SINGLE and has_triggered:
		return
	
	if body is PlayerController:
		has_triggered = true
		
		if delay > 0.0:
			await get_tree().create_timer(delay).timeout
			
	_activate_targets(body)
	
func _on_body_exited(body: Node3D) -> void:
	if trigger_type != trigger_types.ON_EXIT:
		return
		
	if body is PlayerController:
		_deactivate_targets(body)

func _activate_targets(player: Node3D) -> void:
	if targets.is_empty():
		return
	
	var entities = get_tree().get_nodes_in_group("map_entities")
	
	for target_name in targets:
		for entity in entities:
			if entity.has_method("get_targetname") and entity.get_targetname() == target_name:
				if entity.has_method("on_trigger"):
					entity.on_trigger(player)

func _deactivate_targets(body: Node3D) -> void:
	pass
