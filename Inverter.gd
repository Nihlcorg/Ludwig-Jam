extends CheckButton

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pressed" : is_pressed(),
		"pos_x" : rect_position.x,
		"pos_y" : rect_position.y,
		"connect_signal" : "shift",
		"connect_method" : "setting_changed",
	}
	return save_dict

signal shift(on)

func _on_Inverter_toggled(button_pressed):
	emit_signal('shift', is_pressed())
