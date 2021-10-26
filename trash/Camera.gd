extends Control

onready var Viewport = get_viewport()
var leftBound
var absLeft
var upBound
var absUp
var rightBound
var absRight
var lowBound
var absLow
var origin = Vector2()
var mode
var follow

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	mode = 'stay'
	get_bounds()
	set_absolutes(rect_position, rect_size)

func get_bounds():
	leftBound = self.rect_position.x
	upBound = self.rect_position.y
	rightBound = self.rect_position.x + self.rect_size.x
	lowBound = self.rect_position.y + self.rect_size.y

func set_absolutes(pos, size):
	absLeft = pos.x 
#	absUp = pos.y
	absRight = size.x 
	absLow = size.y 

func _process(delta):
	if follow:
		if not get_rect().has_point(follow.global_position):
			var point = follow.global_position.y
			if point < upBound:
				translate(Vector2(0, 100))
			if point > lowBound:
				translate(Vector2(0, -100))
#			print('outie')
#			var difference = upBound + follow.global_position.y
#			print (difference)
#			translate(Vector2(0, 100))
			pass
		pass
	
func check_bounds(vector):
	if vector.x > 0:
		if leftBound <= absLeft:
			vector.x = 0
	if vector.x < 0:
		if rightBound >= absRight:
			vector.x = 0
	if vector.y > 0:
		if upBound <= absUp:
			vector.y = 0
	if vector.y < 0:
		if lowBound >= absLow:
			vector.y = 0
	return vector

func translate(vector):
#	vector = check_bounds(vector)
	var start = Viewport.get_global_canvas_transform()
	start = start.translated(vector)
	start *= Transform2D(0, vector)
	Viewport.set_global_canvas_transform(start)
	origin += vector
#	follow.global_position += vector
	rect_position += vector * -1
	get_bounds()
