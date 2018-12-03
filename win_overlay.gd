extends CanvasLayer

func _ready():
	add_to_group("you_win")

func you_win():
	$animation_player.play("you_win")
