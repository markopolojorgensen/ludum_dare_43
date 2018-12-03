extends RigidBody2D

signal injured

var attack_scene = preload("res://player/attack/attack.tscn")

var ouched = false
var you_win = false

func _ready():
	add_to_group("you_win")
	
	$animated_sprite.play()

func _integrate_forces(state):
	if not ouched and not you_win:
		$TopDownMovement.do_movement(state)

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		attack()

func hit(thing):
	# print("player was hit by a thing: " + thing.name)
	
	if $ouch_timer.is_stopped():
		
		# take damage
		emit_signal("injured")
		
		# hop backwards
		var impulse = -3 * $TopDownMovement.max_speed * linear_velocity.normalized()
		apply_impulse(Vector2(), impulse)
		
		# briefly stunned
		ouched = true
		
		$ouch_timer.start()
		yield($ouch_timer, "timeout")
		
		ouched = false

func attack():
	if $attack_cooldown.is_stopped():
		var inst = attack_scene.instance()
		inst.direction = linear_velocity.normalized()
		
		get_parent().add_child(inst)
		
		inst.global_position = global_position + (60 * linear_velocity.normalized())
		
		$attack_cooldown.start()

func you_win():
	you_win = true

