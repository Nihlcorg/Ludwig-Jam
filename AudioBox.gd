extends HBoxContainer

onready var slider = get_node("Slider")

var volume setget set_volume, get_volume

signal volume_changed()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		'volume' : get_volume(),
		"pos_x" : rect_position.x,
		"pos_y" : rect_position.y,
		"connect_signal" : "volume_changed",
		"connect_method" : "setting_changed"
	}
	return save_dict


func set_volume(vol):
	slider.value = vol

func get_volume():
	return slider.value

func _on_Slider_value_changed(value):
	emit_signal("volume_changed")
