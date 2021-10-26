extends Area2D

signal pitfall(node)

func _ready():
	connect('body_entered', self, 'fall')

func fall(body):
	print('pitfall')
	emit_signal('pitfall', self)
