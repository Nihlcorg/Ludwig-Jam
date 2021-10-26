# This script manages a flipper.
#Shoutouts to Dbisdorf whose pinball source code I yoinked for these flippers
# his repo: https://github.com/dbisdorf/professor-pinball

extends Node2D

# On a given flipper instance, you can override the exported parameters using the Godot inspector.

# The flipper takes this long to traverse its arc.
export var snap_time = 0.25

# The flipper's arc is this big, in degrees.
export var snap_angle = 50

var intermediate_time = 0.0

func _physics_process(delta):
#	if Input.is_action_just_pressed():
#		$AudioStreamPlayer.play()
#		pass
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if intermediate_time < snap_time:
			intermediate_time += delta
			if intermediate_time > snap_time:
				intermediate_time = snap_time
			$RigidBody2D.set_rotation_degrees((intermediate_time / snap_time) * snap_angle)
	else:
		if intermediate_time > 0:
			intermediate_time -= delta
			if intermediate_time < 0:
				intermediate_time = 0
			$RigidBody2D.set_rotation_degrees((intermediate_time / snap_time) * snap_angle)
