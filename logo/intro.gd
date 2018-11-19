extends CenterContainer

export(bool) var skip = false

func _ready():
	resize_window()
	
	if skip:
		exit_intro()
	
	$intro_timer.connect("timeout", self, "exit_intro")
	$fade_timer.connect("timeout", self, "unblur")
	
	$AnimationPlayer.play("fade in")

func unblur():
	$Control/AnimatedSprite.play()

func exit_intro():
	get_tree().quit()
	get_tree().change_scene("res://game.tscn")

func resize_window():
	# OS.set_window_size(Vector2(1024, 600))
	
	var screen_size = OS.get_screen_size(0)
	var window_size = OS.get_window_size()
	
	OS.set_window_position((screen_size - window_size) * 0.5)


