extends StaticBody2D

# set when instanced!
var player

var attack_scene = preload("res://story/diamond/wobble_ring.tscn")
var attack_impulse = 600
var initial_offset = 50

export(float) var time = 0

onready var initial_position = position

var radius = 700

func _ready():
	$attack_interval.connect("timeout", self, "attack")
	
	$initial_attack_delay.wait_time = randf() * 3
	$initial_attack_delay.start()
	yield($initial_attack_delay, "timeout")
	
	$attack_interval.start()
	
	add_to_group("you_win")
	
	if global.you_win:
		you_win()
	

func attack():
	var inst = attack_scene.instance()
	
	get_parent().add_child(inst)
	
	var aim = (player.global_position - global_position).normalized()
	
	inst.global_position = global_position + (aim * initial_offset)
	
	var impulse = aim * attack_impulse
	inst.apply_impulse(Vector2(), impulse)

func _process(delta):
	time += delta / 2.0
	
	var direction = Vector2()
	var sin_weight = ((sin(time)+1)/2)
	var cos_weight = abs(cos(time))
	direction.x = lerp(-1.2, 1.2, sin_weight)
	direction.y = lerp(0, 1, cos_weight)
	position = initial_position + (direction * radius)

func you_win():
	queue_free()

