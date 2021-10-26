# This script manages a flipper.
#Shoutouts to Dbisdorf whose pinball source code I yoinked for these flippers
# his repo: https://github.com/dbisdorf/professor-pinball

extends Node2D

# On a given flipper instance, you can override the exported parameters using the Godot inspector.

# Use this control to operate the flipper.
# Unfortunately Godot 3.x can't tell the difference between the left and right shift keys,
# so you may not want to use the shift keys for your flippers.
export var keycode = "ui_left"

# The flipper takes this long to traverse its arc.
export var snap_time = 0.1


# The flipper's arc is this big, in degrees.
export var snap_angle = 50

var intermediate_time = 0.0

func switch(layer, on):
	$RigidBody2D.set_collision_layer_bit(layer, on)

func _physics_process(delta):
	if Input.is_action_pressed('ui_space'):
#	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
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
