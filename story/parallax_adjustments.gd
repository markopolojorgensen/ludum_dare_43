extends ParallaxLayer

func _ready():
	for child in get_children():
		child.position *= motion_scale

