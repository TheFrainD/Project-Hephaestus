extends Spatial

onready var pivot = $Pivot
onready var bolt = $Bolt
onready var arrows = $Arrows
onready var animation_player = $AnimationPlayer

func _shoot(angle: float):
	pivot.visible = true
	bolt.visible = true
	arrows.visible = false
	rotation_degrees.y = angle
	animation_player.play("appearing")
	Events.emit_signal("player_made_turn")


func _on_forward_arrow_input_event(camera, event, position, normal, shape_idx):
	if event as InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_shoot(0)


func _on_back_arrow_input_event(camera, event, position, normal, shape_idx):
	if event as InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_shoot(180)


func _on_left_arrow_input_event(camera, event, position, normal, shape_idx):
	if event as InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_shoot(90)


func _on_right_arrow_input_event(camera, event, position, normal, shape_idx):
	if event as InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_shoot(270)
