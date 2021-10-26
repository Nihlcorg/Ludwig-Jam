extends RigidBody2D

#func _unhandled_input(event):
#	if event is InputEventMouseMotion:
#		position = event.position
##		linear_velocity = event.speed

func _process(delta):
	global_position = get_global_mouse_position()
