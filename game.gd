extends Node

var player_max_health = 8
var player_health = 8

var boss_max_health = 8
var boss_health = 8

func _ready():
	global.you_win = false
	
	$world/fight/trigger.connect("body_entered", self, "start_fight")
	
	$world/y_sort/player.connect("injured", self, "player_damage")
	$world/y_sort/boss.connect("injured", self, "boss_damage")
	
	for heart in $hud/margin_container/h_box_container.get_children():
		heart.get_node("full_heart").play()
	
	$hud/boss_health.hide()
	
	$fade_in/tween.interpolate_property($fade_in/sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$fade_in/tween.start()
	
	setup_music_triggers()


func setup_music_triggers():
	for trigger in $world/music_triggers.get_children():
		trigger.connect("body_entered", $music_manager, "add_track")
		trigger.connect("body_entered", self, "trigger_happy", [trigger])

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func start_fight(player):
	# disable trigger (don't restart fight!)
	$world/fight/trigger/collision_shape_2d.disabled = true
	
	# hide willowisp
	$world/fight/willowisp_5.stop()
	$world/fight/willowisp_5.hide()
	
	# hide text
	$world/fight/sac_5.hide()
	
	# start fires
	get_tree().call_group("disabled_gas", "start")
	
	# show boss
	$world/y_sort/boss.show()
	
	# show boss health
	$hud/boss_health.show()
	for heart in $hud/boss_health/h_box_container.get_children():
		heart.get_node("full_heart").play()
	
	# summon two diamonds to start
	$world/y_sort/boss.summon(0)
	$world/y_sort/boss.summon(1)

func player_damage():
	player_health -= 1
	
	if player_health <= 0:
		get_tree().change_scene("res://game_over.tscn")
	
	var i = player_max_health
	while i > player_health:
		get_node("hud/margin_container/h_box_container/heart" + str(i) + "/full_heart").hide()
		i -= 1

func boss_damage():
	boss_health -= 1
	
	if boss_health <= 0:
		# you win!
		$world/y_sort/boss.die()
		global.you_win = true
		get_tree().call_group("you_win", "you_win")
	
	var missing_health = boss_max_health - boss_health
	var i = 0
	while i < missing_health:
		get_node("hud/boss_health/h_box_container/heart" + str(i) + "/full_heart").hide()
		i += 1

# prevent one trigger from tripping multiple times
func trigger_happy(thing, trigger):
	yield(get_tree().create_timer(0.2), "timeout")
	# print(thing.name)
	# print(trigger.name)
	
	trigger.queue_free()
	