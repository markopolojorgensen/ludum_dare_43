extends Node2D

export(NodePath) var player_path
onready var player = get_node(player_path)

export(float) var max_distance = 400.0
export(float) var max_opacity = 0.25

export(bool) var invert = false
export(float) var inverted_distance_adjustment = 300

func _process(delta):
	# hack for using fades with non-parallax
	var adjusted_position = global_position
	if "motion_scale" in get_parent():
		# there's a reason for not using global position here
		# I don't know what it is at the moment
		adjusted_position = position / get_parent().motion_scale
	var distance = (player.global_position - adjusted_position).length()
	var weight = distance / max_distance
	
	# closer you are, the higher the opacity
	var opacity = lerp(max_opacity, 0, weight)
	
	if invert:
		# fade out before getting right on top of it
		weight = (distance - inverted_distance_adjustment) / max_distance
		
		# closer you are, the lower the opacity
		opacity = lerp(0, 1, weight)
	
	
	modulate = Color(1, 1, 1, opacity)
	




