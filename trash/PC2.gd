extends KinematicBody2D

var vertical_speed := 0.0
var screen_size
var jump_counter = 0
onready var plat_detect = $plat_detector
#jump physics vars
export var vJump = 600
var maxGrav = 600
export var gravity = 50
export var sWalk = 200
var velocity = Vector2()

#var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


func _physics_process(delta):
#	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
			velocity.x = sWalk
	elif Input.is_action_pressed("ui_left"):
			velocity.x = -sWalk
	else:
		velocity.x = 0
#	if Input.is_action_pressed("ui_down"):
#			velocity.y = sWalk
#	elif Input.is_action_pressed("ui_up"):
#			velocity.y = -sWalk
#	else:
#		velocity.y = 0
#	vertical_movement(delta)
	if plat_detect.is_colliding():
		jump_counter = 0
		vertical_movement(false)
	else: 
		vertical_movement(true)
	var k = move_and_slide(velocity, Vector2(0, -1))

func start(pos):
	position = pos
	#target = pos
	show()
	$CollisionShape2D.disabled = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_select") && jump_counter < 2 :
		velocity.y = -vJump
		jump_counter +=1

func vertical_movement(grav):
	if grav:
		if velocity.y < maxGrav:
			velocity.y += gravity
	else:
		if velocity.y >  0:
			velocity.y -= gravity
#	var local_Y = Vector2.UP
#	var k = move_and_slide(velocity, Vector2(0,-1)) 
