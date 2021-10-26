extends Position2D

onready var rBump = $RBumper/StaticBody2D
onready var lBump = $LBumper/StaticBody2D

func _unhandled_input(event):
#	if event.is_action_pressed("ui_right"):
#		$AnimationPlayer.play("Rbump")
#	if event.is_action_released("ui_right"):
#		$AnimationPlayer.play("Rfall")
#	if event.is_action_pressed("ui_left"):
#		$AnimationPlayer.play("Lbump")
#	if event.is_action_released("ui_left"):
#		$AnimationPlayer.play("Lfall")
	if event.is_action_pressed("ui_down"):
		$AnimationPlayer.play("flatup")
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed(): $AnimationPlayer.play("Lbump")
			else: $AnimationPlayer.play("Lfall")
		if event.button_index == BUTTON_RIGHT:
			if event.is_pressed(): $AnimationPlayer.play("Rbump")
			else: $AnimationPlayer.play("Rfall")
	if event.is_action_released("ui_down"):
		$AnimationPlayer.play_backwards("flatup")
	if event is InputEventMouseMotion:
		position.x = event.position.x

func _process(delta):
	global_position.x = get_global_mouse_position().x
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
