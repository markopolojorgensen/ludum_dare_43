extends Node

var tracks = 0

func _ready():
	$bass.play()
	fade_in($bass)

# only need thing to be wired up to body entered
func add_track(thing):
	match tracks:
		0:
			fade_in($percussion)
		1:
			fade_in($lead)
		2:
			fade_in($horns)
		3:
			print("wat")
	
	tracks += 1

func fade_in(track):
	print("fading in " + track.name)
	track.play($bass.get_playback_position())
	$tween.interpolate_property(track, "volume_db", -60, 0, 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.start()

func _on_area_2d_body_entered(body):
	add_track()

# never call this, I guess :(
func boss():
	$bass.stop()
	$percussion.stop()
	$lead.stop()
	$horns.stop()
	$boss.play(0)

