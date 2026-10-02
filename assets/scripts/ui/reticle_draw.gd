@tool
extends Control

@export var radius : float = 30.0 : set = set_crosshair_radius
@export var thickness : float = 1.0 : set = set_crosshair_thickness
@export var color : Color = Color.WHITE : set = set_crosshair_color
@export var gap_angle : float = 45.0 : set = set_crosshair_gap_angle
@export var segments : int = 32 : set = set_crosshair_segments

func _draw() -> void:
	draw_circle_crosshair()
	
func draw_circle_crosshair() -> void:
	var gap_rad = deg_to_rad(gap_angle)
	
	var arc_segments = [
		#Bottom right quadrant
		[gap_rad/2, PI/2 - gap_rad/2],
		#Bottom left quadrant
		[PI/2 + gap_rad/2, PI/2 - gap_rad/2],
		#Top left quadrant
		[PI + gap_rad/2, 3*PI/2 - gap_rad/2],
		#Top right quadrant
		[3*PI/2 + gap_rad/2, 2*PI - gap_rad/2]
	]
	
	for arc in arc_segments:
		var start_angle = arc[0]
		var end_angle = arc[1]


func set_crosshair_radius(val : float) -> void:
	pass
	
func set_crosshair_thickness(val : float) -> void:
	pass

func set_crosshair_color(val : Color) -> void:
	pass

func set_crosshair_gap_angle(val : float) -> void:
	pass

func set_crosshair_segments(val : int) -> void:
	pass
