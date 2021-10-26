extends RigidBody2D

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			apply_central_impulse(Vector2(0, -1000))
