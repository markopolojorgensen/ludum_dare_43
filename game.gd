extends Node

func _ready():
	# get_tree().quit()
	pass


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
