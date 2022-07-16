extends Node
class_name StateMachine

export var initial_state = NodePath()

onready var state: State = get_node(initial_state) setget set_state
onready var _state_name = state.name

func _init():
	add_to_group("state_machine")


func _ready():
	yield(owner, "ready")
	state.enter()


func _unhandled_input(event):
	state.unhandled_input(event)


func _process(delta):
	state.process(delta)


func _physics_process(delta):
	state.physics_process(delta)


func transition_to(target_state_path, msg: Dictionary = {}):
	if not has_node(target_state_path):
		return
	
	var target_state = get_node(target_state_path)
	
	state.exit()
	self.state = target_state
	state.enter(msg)

func set_state(value):
	state = value
	_state_name = state.name
