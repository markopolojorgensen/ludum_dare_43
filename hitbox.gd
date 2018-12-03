extends Area2D

signal hit_something(thing)

func _ready():
	connect("body_entered", self, "hit_a_thing")
	connect("area_entered", self, "hit_a_thing")

func hit_a_thing(body):
	emit_signal("hit_something", body)

func disable():
	$collision_shape_2d.set_disabled(true)

func enable():
	$collision_shape_2d.set_disabled(false)

