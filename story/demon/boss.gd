extends StaticBody2D

signal injured
signal borked

export(NodePath) var player_path
onready var player = get_node(player_path)

var diamond_scene = preload("res://story/diamond/diamond_enemy.tscn")
var diamond_offset = Vector2(0, 200)

var borked = false

func _ready():
	hide()

func hit(thing):
	# print("boss hit by " + thing.name)
	
	if $ouch_duration.is_stopped():
		# take damage
		emit_signal("injured")
		
		# flash
		$animation_player.play("ouch")
		
		$ouch_duration.start()
		
		summon(0)
	

func summon(time_offset):
	var inst = diamond_scene.instance()
	
	inst.player = player
	inst.time = time_offset
	
	# get_parent().add_child(inst)
	get_parent().call_deferred("add_child", inst)
	inst.global_position = global_position + diamond_offset
	inst.initial_position = global_position + diamond_offset
	

func die():
	emit_signal("borked")
	borked = true
	
	queue_free()

