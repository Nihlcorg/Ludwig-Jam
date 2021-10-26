extends Node2D
#
#func _physics_process(delta):
#	global_position.x = get_global_mouse_position().x

#Shoutouts to Dbisdorf whose pinball source code I yoinked for these flippers
# his repo: https://github.com/dbisdorf/professor-pinball
func switch(layer, on):
	$LFlip/RigidBody2D.set_collision_layer_bit(layer, on)
	$RFlip/RigidBody2D.set_collision_layer_bit(layer, on)
