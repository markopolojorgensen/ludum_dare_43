extends StaticBody2D

signal borked

func _ready():
	# godot bug? inherited scene disregards editor-set collision layer
	# print(name + ": " + str(collision_layer))
	collision_layer = 5 # super sketch workaround
	
	$animated_sprite.play()
	$light.show()

func hit(thing):
	print("machine hit by " + thing.name)
	
	$light.hide()
	$animated_sprite.stop()
	$animated_sprite.frame = 0
	
	emit_signal("borked")

