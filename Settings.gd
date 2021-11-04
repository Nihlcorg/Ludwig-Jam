extends Control

onready var tree = get_tree()
onready var sound = $SoundBox
onready var music = $MusicBox
onready var inverter = $Inverter
onready var speed = $Speed

signal menu(on)
signal sound_changed(vol)
signal invert_controls()
signal speed_change(index)
signal save_quit()

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
#	print('save')
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save2"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		# Call the node's save function.
		var node_data = node.call("save2")
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func _on_QuitBtn_pressed():
	$ControlBtn.set_pressed(false)
	$AudioBtn.set_pressed(false)
	tree.call_group('audio', 'set_visible', false)
	tree.call_group('controls', 'set_visible', false)
	tree.call_group('quit', 'set_visible', true)

func _on_ControlBtn_pressed():
	$AudioBtn.set_pressed(false)
	$QuitBtn.set_pressed(false)
	tree.call_group('audio', 'set_visible', false)
	tree.call_group('controls', 'set_visible', true)
	tree.call_group('quit', 'set_visible', false)

func _on_AudioBtn_pressed():
	$ControlBtn.set_pressed(false)
	$QuitBtn.set_pressed(false)
	tree.call_group('audio', 'set_visible', true)
	tree.call_group('controls', 'set_visible', false)
	tree.call_group('quit', 'set_visible', false)

func save2():
	var save_dict = {
		"sound" : sound.volume,
		"music" : music.volume,
		"inverter" : inverter.is_pressed(),
		"speed" : speed.selected
	}
	return save_dict

# %APPDATA%\Godot\ file path for save data on windows
func load2():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		music.volume = node_data["music"]
		sound.volume = node_data["sound"]
		inverter.set_pressed(node_data["inverter"])
		speed.select(node_data['speed'])
	save_game.close()
	if music.volume > 0: $MusicPlayer.play()

func setting_changed():
#	print('change')
	if music.volume > 0: 
		if not $MusicPlayer.is_playing():
			$MusicPlayer.play()
	else: $MusicPlayer.stop()
	emit_signal("sound_changed", sound.volume)
	save_game()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if is_visible():
			emit_signal("menu", true)
		else:
			emit_signal("menu", false)

func menu_switch(boolean, pos):
	get_tree().paused = boolean
	set_visible(boolean)
	rect_position = pos

func get_musicvol():
	return $MusicBox.volume

func get_soundvol():
	var box = get_node("/root/Settings/SoundBox")
	return box.get_volume()

func _on_Inverter_shift(switch):
	emit_signal("invert_controls", switch)
	save_game()

func _on_justquit_pressed():
	get_tree().quit()

func _on_savequit_pressed():
	emit_signal("save_quit")

func _on_Settings_save_quit():
	pass # Replace with function body.

func _on_Speed_item_selected(index):
	emit_signal("speed_change", index)
	save_game()

func _on_reset_pressed():
	var dir = Directory.new()
	dir.remove("user://savelevel.save")
