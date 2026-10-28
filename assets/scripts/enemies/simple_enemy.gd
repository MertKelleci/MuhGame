class_name SimpleEnemy extends BaseEnemy

@export var follow_speed := 3.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_chart: StateChart = $StateChart
@onready var health_component: HealthComponent = $HealthComponent

var target: Node3D

func _ready() -> void:
	super._ready()
	
	target = get_tree().get_first_node_in_group("player")
	
	health_component.died.connect(_on_died)
	nav_agent.velocity_computed.connect(_on_velocity_computed)
