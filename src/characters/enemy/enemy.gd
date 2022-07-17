extends KinematicBody

export var speed = 4.0
export var gravity = 90.0

onready var tween = $Tween
onready var model = $Pivot/Model

var _velocity = Vector3.ZERO

func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		move(Vector3.RIGHT)
	
	_velocity.y -= gravity * delta
	_velocity = move_and_slide(_velocity, Vector3.UP)


func make_turn():
	move(Vector3.RIGHT)
	return true


func move(direction):
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
			model.global_transform.origin + direction * detection_range + Vector3.DOWN * 0.4, [self])
	if collision:
		return
	
	tween.interpolate_property(self, "translation",
			self.global_transform.origin, self.global_transform.origin + direction * 2, 
			1 / speed, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
	yield(tween, "tween_all_completed")
