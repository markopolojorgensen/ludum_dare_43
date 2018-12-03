extends Node2D

export(NodePath) var machine_path
var machine

export(bool) var continuous = false

export(float) var interval = 2.5

export(float) var max_delay = 2.5
export(float) var forced_delay = 0

# automatically starts things
# if false, you must call start()
export(bool) var enabled = true

export(bool) var quiet = false

func _ready():
	if machine_path:
		machine = get_node(machine_path)
		
		# delete self when machine borks
		machine.connect("borked", self, "queue_free")
	
	$hitbox.connect("hit_something", self, "hit_something")
	$hitbox.disable()
	
	if enabled:
		start()
	else:
		add_to_group("disabled_gas")
		$continuous.hide()
		$burst.hide()
	
	if quiet:
		$burst_audio.volume_db -= 20
	

func start():
	# initial delay to make sure they're not all in sync
	var time = (randf() * max_delay) + forced_delay
	
	yield(get_tree().create_timer(time), "timeout")
	
	if continuous:
		$hitbox.enable()
		
		$continuous.show()
		$continuous.play()
		$burst.hide()
		
		$burst_interval.stop()
		
		$burst_audio/timer.start()
		$burst_audio/timer.connect("timeout", $burst_audio, "play")
	else:
		$continuous.hide()
		$burst.show()
		
		$burst_interval.connect("timeout", self, "burst")
		$burst_interval.wait_time = interval
		
		$burst_interval.start()
		burst()

func burst():
	if continuous:
		print("nah bro")
	else:
		$hitbox.enable()
		$burst.play()
		$burst.frame = 0
		
		$burst_audio.play()
		
		$burst_duration.start()
		
		yield($burst_duration, "timeout")
		$hitbox.disable()

func hit_something(body):
	if body.has_method("hit"):
		body.hit(self)

# too stronk, not a thing any more
func ex_poof(thing):
	# print("poofed by " + thing.name)
	$hitbox.disable()
	$burst.stop()
	$burst.frame = 0
	# relies on burst duration to start again

