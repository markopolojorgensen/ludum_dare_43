extends RigidBody2D

func _ready():
	$animated_sprite.play()

func _integrate_forces(state):
	$TopDownMovement.do_movement(state)
