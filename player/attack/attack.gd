extends Node2D

# this had better be normalized
var direction

var speed = 400

func _ready():
	$hitbox.connect("hit_something", self, "hit_something")
	
	# give me 0,0 or 0,1 or -1, 1 or similar
	direction.x = stepify(direction.x, 1.0)
	direction.y = stepify(direction.y, 1.0)
	
	if direction.x == -1:
		if direction.y == -1:
			$sprite4.show()
		if direction.y == 0:
			$sprite3.show()
		if direction.y == 1:
			$sprite2.show()
	elif direction.x == 0:
		if direction.y == -1:
			$sprite5.show()
		if direction.y == 0 or direction.y == 1:
			# (includes 0, 0 for when not moving)
			$sprite1.show()
	elif direction.x == 1:
		if direction.y == -1:
			$sprite6.show()
		if direction.y == 0:
			$sprite7.show()
		if direction.y == 1:
			$sprite8.show()
	
	$tween.interpolate_property($sprite1, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property($sprite2, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property($sprite3, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property($sprite4, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property($sprite5, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property($sprite6, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property($sprite7, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property($sprite8, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.start()
	
	yield($tween, "tween_completed")
	
	queue_free()

func _process(delta):
	position += direction * speed * delta

func hit_something(thing):
	# print("hit a " + thing.name)
	if thing.name == "hitbox":
		thing = thing.get_parent()
	
	if thing.has_method("poof"):
		thing.poof(self)
		return # don't queue_free()
		
	elif thing.has_method("hit"):
		thing.hit(self)
	
	queue_free()

