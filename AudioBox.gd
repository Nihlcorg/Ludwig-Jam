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

func _ready():
	volume = get_volume()
	mod_bus(volume)

func set_volume(vol):
	slider.value = vol

func get_volume():
	return slider.value

func _on_Slider_value_changed(value):
	mod_bus(value)
	emit_signal("volume_changed")

export var audio_bus_name := "Master"

onready var _bus := AudioServer.get_bus_index(audio_bus_name)

#func _ready() -> void:
#	value = db2linear(AudioServer.get_bus_volume_db(_bus))

func mod_bus(value: float):
	AudioServer.set_bus_volume_db(_bus, linear2db(value))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear2db(value))
