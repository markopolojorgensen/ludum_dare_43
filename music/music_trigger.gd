extends Area2D

func _process(delta):
	if int(global_position.y) % 2 == 0:
		global_position.y += 1
	else:
		global_position.y -= 1



