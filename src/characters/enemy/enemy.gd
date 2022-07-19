extends KinematicBody

class_name Enemy

export var speed = 4.0
export var gravity = 90.0
export var max_health = 3
export (Global.damage_type) var vulnerability = Global.damage_type.FIRE

onready var tween = $Tween
onready var model = $Pivot/Model

var _velocity = Vector3.ZERO

onready var _health = max_health setget set_health

func _physics_process(delta):
	_velocity.y -= gravity * delta
	_velocity = move_and_slide(_velocity, Vector3.UP)


func make_turn():
	move(Vector3.RIGHT)
	return true


func move(direction):
	var detection_range = 2.5
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(global_transform.origin,
			global_transform.origin + direction * detection_range, [self])
	collision = collision or space.intersect_ray(global_transform.origin,
			global_transform.origin + direction * detection_range + Vector3.UP * 0.75, [self])
	collision = collision or space.intersect_ray(global_transform.origin,
			global_transform.origin + direction * detection_range + Vector3.UP * 0.4, [self])
	collision = collision or space.intersect_ray(global_transform.origin,
			global_transform.origin + direction * detection_range + Vector3.DOWN * 0.6, [self])
	collision = collision or space.intersect_ray(global_transform.origin,
			global_transform.origin + direction * detection_range + Vector3.DOWN * 0.4, [self])
	if collision:
		return
	
	tween.interpolate_property(self, "translation",
			self.global_transform.origin, self.global_transform.origin + direction * 2, 
			1 / speed, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
	yield(tween, "tween_all_completed")


func _on_hurtbox_area_entered(area):
	if area.type == vulnerability:
		self._health = 0
	else:
		self._health -= 1


func set_health(value):
	_health = value
	if _health <= 0:
		die()


func die():
	Events.emit_signal("enemy_died")
	queue_free()
