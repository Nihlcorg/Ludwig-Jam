extends RigidBody2D

var speedMin = 200

func _integrate_forces(state):
	var force = state.get_linear_velocity()
#	print(force)
	var newForce = Vector2()
	if force.x < speedMin && force.x > -speedMin:
		newForce.x = speedMin * force.sign().x
	if force.y < speedMin && force.y > -speedMin:
		newForce.y = speedMin * force.sign().y
	apply_impulse(Vector2(), newForce)
	pass
