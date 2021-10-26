extends RigidBody2D

onready var cue = $Contact/Cue
onready var contact = $Contact
onready var charge = $Contact/Cue/Charge

var clock = false
var unclock = false
var moving = false
var powerCharge = false
var chargeRate = 10
var powerLim = 1000
var power = 0
var slope = Vector2()
var slap = Vector2()

func _ready():
	charge.max_value = powerLim

func _unhandled_input(event):
	if not moving:
		if event.is_action_pressed("ui_left"):
			print('left')
			unclock = true
			clock = false
		if event.is_action_pressed("ui_right"):
			clock = true
			unclock = false
		if event.is_action_released("ui_left"):
			unclock = false
		if event.is_action_released("ui_right"):
			clock = false
		if event.is_action_pressed("ui_down"):
			powerCharge = true
			pass
		if event.is_action_released("ui_down"):
			powerCharge = false
			get_force()

func _process(delta):
	if clock == true && not moving:
		contact.rotation_degrees += 2
	if unclock == true && not moving:
		contact.rotation_degrees -= 2
	if powerCharge == true && power < powerLim:
		power += chargeRate
#		print(power)
	charge.value = power
	calculate_slope()

func _integrate_forces(state):
	var linvel = state.get_linear_velocity().floor()
#	print(linvel)
	if linvel < Vector2(50, 50): moving = false
	else: moving = true
#	print('force')
	if not (clock && unclock):
#		apply_impulse(contact.global_position, slap)
#		apply_impulse(Vector2(), slap)
#		apply_central_impulse(slap)
#		add_central_force(slap)
		pass
	slap = Vector2()

func calculate_slope():
	var a = cue.global_position.abs()
	var b = contact.global_position.abs()
	slope = a.direction_to(b)

func get_force():
	slap.x = slope.x * power
	slap.y = slope.y * power
	print(power)
	if not (clock && unclock):
		apply_central_impulse(slap)
	power = 0

