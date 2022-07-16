extends Node
class_name State

onready var _state_machine = _get_state_machine(self)

func _unhandled_input(event):
	pass


func process(delta):
	pass


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}):
	pass


func exit():
	pass


func _get_state_machine(node):
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
