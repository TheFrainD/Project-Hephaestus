extends KinematicBody

class_name Player

signal attack_finished
signal made_turn

export var speed = 4.0
export var gravity = 90.0

export (PackedScene) var hepheastus
export (PackedScene) var zeus
export (PackedScene) var artemida

onready var pivot = $Pivot
onready var model = $Pivot/Model
onready var tween = $Tween

var active = true

var _velocity = Vector3.ZERO
var _current_face = 5

func _physics_process(delta):
	_velocity.y -= gravity * delta 
	_velocity = move_and_slide(_velocity, Vector3.UP)


func _process(delta):
	if active and is_on_floor():
		if Input.is_action_pressed("roll_left"):
			_roll(Vector3.RIGHT)
		elif Input.is_action_pressed("roll_right"):
			_roll(Vector3.LEFT)
		elif Input.is_action_pressed("roll_up"):
			_roll(Vector3.BACK)
		elif Input.is_action_pressed("roll_down"):
			_roll(Vector3.FORWARD)
		elif Input.is_action_just_pressed("attack"):
			_attack()


func _roll(direction):
	if tween.is_active():
		return false
	
	var detection_range = 2.5
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(model.global_transform.origin,
			model.global_transform.origin + direction * detection_range, [self])
	collision = collision or space.intersect_ray(model.global_transform.origin,
			model.global_transform.origin + direction * detection_range + Vector3.UP * 0.75, [self])
	collision = collision or space.intersect_ray(model.global_transform.origin,
			model.global_transform.origin + direction * detection_range + Vector3.UP * 0.4, [self])
	collision = collision or space.intersect_ray(model.global_transform.origin,
			model.global_transform.origin + direction * detection_range + Vector3.DOWN * 0.65, [self])
	collision = collision or space.intersect_ray(model.global_transform.origin,
			model.global_transform.origin + direction * detection_range + Vector3.DOWN * 0.45, [self])
	if collision:
		return false
	
	active = false
	
	Events.emit_signal("player_moved", direction.x)
	
	pivot.translate(direction * 0.8)
	model.global_translate(-direction * 0.8)
	
	var axis = direction.cross(Vector3.DOWN)
	tween.interpolate_property(pivot, "transform:basis",
			null, pivot.transform.basis.rotated(axis, PI/2),
			1 / speed, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.interpolate_property(pivot, "transform:basis",
			null, pivot.transform.translated(direction * 2),
			1 / speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	
	pivot.translate(-direction * 2)
	transform.origin += direction * 2
	var preserved_basis = model.global_transform.basis
	pivot.transform = Transform.IDENTITY
	model.transform.origin = Vector3(0, 1, 0)
	model.global_transform.basis = preserved_basis
	
	Events.emit_signal("player_made_turn")


func _attack():
	if _current_face == 1:
		active = false
		var hepheastus_instance = hepheastus.instance()
		add_child(hepheastus_instance)
		hepheastus_instance.translate(Vector3.UP * 1.6)
		
		Events.emit_signal("player_made_turn")
	elif _current_face == 3:
		active = false
		var zeus_instance = zeus.instance()
		get_tree().get_root().add_child(zeus_instance)
		zeus_instance.translate(global_transform.origin + Vector3.UP * 1.6)
	elif _current_face == 6:
		active = false
		var artemida_instance = artemida.instance()
		get_tree().get_root().add_child(artemida_instance)
		artemida_instance.translate(global_transform.origin + Vector3.UP * 1.6)
	else:
		return false
	
	emit_signal("attack_finished")


func _on_tween_step(object, key, elapsed, value):
	pivot.transform = pivot.transform.orthonormalized()


func _on_face_detector_entered(area):
	if area.name == "One":
		_current_face = 1
	elif area.name == "Two":
		_current_face = 2
	elif area.name == "Three":
		_current_face = 3
	elif area.name == "Four":
		_current_face = 4
	elif area.name == "Five":
		_current_face = 5
	elif area.name == "Six":
		_current_face = 6
