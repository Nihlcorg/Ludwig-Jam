extends Control

onready var tree = get_tree()

func _on_QuitBtn_pressed():
	tree.call_group('audio', 'set_visible', false)
	tree.call_group('controls', 'set_visible', false)
	tree.call_group('quit', 'set_visible', true)

func _on_ControlBtn_pressed():
	tree.call_group('audio', 'set_visible', false)
	tree.call_group('controls', 'set_visible', true)
	tree.call_group('quit', 'set_visible', false)

func _on_AudioBtn_pressed():
	tree.call_group('audio', 'set_visible', true)
	tree.call_group('controls', 'set_visible', false)
	tree.call_group('quit', 'set_visible', false)
