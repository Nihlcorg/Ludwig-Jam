extends Label

var secs = 0
var mins = 0
#var millis = 0

func _on_Timer_timeout():
#	millis += 1
#	if millis == 100:
#		secs += 1
#		millis = 0
	secs += 1
	if secs == 60:
		mins += 1
		secs = 0
	get_time()

func get_time():
	var secString
#	var milliString
#	if millis < 10 : milliString = '0' + millis as String
#	else: milliString = millis as String
	if secs < 10: secString = '0'+secs as String
	else: secString = secs as String
	set_text(mins as String + ':' + secString) # + ':' + milliString) 

func _physics_process(delta):
	var transform = get_tree().get_root().get_canvas_transform()
	rect_position = (transform.get_origin() * -1) # + Vector2(50, 0)

func stop():
	$Timer.stop()

func start():
	$Timer.start()