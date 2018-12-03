extends RigidBody2D

func _ready():
	connect("body_entered", self, "hit_something")
	
	add_to_group("you_win")

func hit_something(thing):
	if thing.has_method("hit"):
		thing.hit(self)
	
	queue_free()


func poof(thing):
	remove_from_group("you_win")
	
	queue_free()

func you_win():
	queue_free()

