extends 'res://pawns/pawn.gd'

export var dosh = 0

var startPos = self.global_position
var startMov = movement

func _ready():
	print(unit)
	print(info.get(unit)[0])
#	print($AnimatedSprite.get_sprite_frames().get_name())
	$AnimatedSprite.set_sprite_frames(load(info.get(unit)[3]))
	$AnimatedSprite.play("default")

func undo_movement():
	self.global_position = startPos
	self.movement = startMov

func pathing(path):
	startPos = self.global_position
	startMov = movement
#	move PC to position
	if path:
		if movement == 0:
			return
		elif path is Vector2:
			if path != self.global_position:
				move_to(path)
				self.movement -=1
		for point in path:
			if point == self.global_position:
				self.global_position = startPos
				self.movement = startMov
				break
			move_to(point)
			yield(self.get_tree().create_timer(0.25), "timeout")
			self.movement -= 1
		if self.movement == 0 && self.AP == 0: end_turn()
	else:
#		print('illegal!')
		pass

func move_to(target_position):
	var move_direction = (target_position - self.position)
	if move_direction.x < 0:
		$AnimationPlayer.play("walk")
		$AnimatedSprite.set_flip_h(true)
	elif move_direction.x > 0:
		$AnimationPlayer.play("walk")
		if $AnimatedSprite.is_flipped_h():
			$AnimatedSprite.set_flip_h(false)

	$Tween.interpolate_property($AnimatedSprite, "position", - move_direction, Vector2(), 0.25)
	position = target_position
	$AnimatedSprite.position -= move_direction
	$Tween.start()
#	yield($Tween, "tween_completed")

func heal(target, hp):
#	heal player obv
	if target == self:
		$Healthbar.heal(hp)
