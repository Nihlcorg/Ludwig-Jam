extends Node

enum COLLISION {credits,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q}

onready var collayer = ['credits','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q']

onready var levels = get_tree().get_nodes_in_group('levels')

onready var billiard = $Billiard
onready var goalPlayer = $GoalPlayer
onready var fallPlayer = $FallPlayer
onready var contact = $Contact
onready var active_level = levels[COLLISION.m]
onready var cage = $cage

#var fall_sound = preload('res://sounds/zapsplat_cartoon_descend_wobble_low_pitched_71601.mp3')
#var goal_sound = preload('res://sounds/zapsplat_cartoon_flutter_delicate_64209.mp3')

func _ready():
#	$Flippers.follow = billiard
#	contact.fallStreak = 5
	contact.link = billiard
	contact.connect('slap', billiard, 'apply_central_impulse')
	levels[COLLISION.m].arrive()
	for level in levels:
		level.connect('fall', self, 'move_down')
		level.connect('goal', self, 'move_up')

func move_down(level, pos):
#	animate transition
	var current = get_level(collayer[level]) 
	var next = get_level(collayer[level-1])
	current.go_away(false)
	next.arrive()
	active_level = next
#	soundPlayer.set_stream(fall_sound)
	fallPlayer.play()
	contact.fallStreak += 1
	print('next '+ next.name)
	print(pos)

func move_up(level, pos):
#	animate transition
	var current = get_level(collayer[level]) 
	var next = get_level(collayer[level+1])
	current.go_away(true)
	next.arrive()
	active_level = next
#	soundPlayer.set_stream(goal_sound)
#	soundPlayer.set_volume_db(-2000.0)
	goalPlayer.play()
	contact.fallStreak = 0
#	print(soundPlayer.get_volume_db())	
#	soundPlayer.set_volume_db(0.0)
	print('next '+ next.name)
	print(pos)
 
func get_level(lvlName):
	for level in levels:
		if level.name == lvlName:
			return level

func _unhandled_input(event):
	if event.is_action_pressed("ui_focus_next"):
#		print('point')
#		var pos = active_level.checkpoint.global_position
#		cage.global_position = billiard.global_position
#		yield(get_tree().create_timer(0.25), "timeout")
#		billiard.global_position = pos
#		cage.global_position = Vector2()
		get_tree().reload_current_scene()

func checkpoint():
	print('point')
	
