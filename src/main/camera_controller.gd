extends Camera

export (NodePath) var player_path
export var smoothing = 4.0
export var offset = Vector3.ZERO
export var x_fixed = false
export var y_fixed = false
export var z_fixed = false

onready var player = get_node(player_path)
onready var target = player.global_transform.origin
onready var start_position = global_transform.origin


func _physics_process(delta):
	target = player.global_transform.origin + offset
	
	if global_transform.origin.distance_to(target) >= 0.1:
		global_transform.origin = global_transform.origin.linear_interpolate(target, delta * smoothing)
		
		if x_fixed:
			global_transform.origin.x = start_position.x
		if y_fixed:
			global_transform.origin.y = start_position.y
		if z_fixed:
			global_transform.origin.z = start_position.z
