extends KinematicBody

export var speed = 4.0

onready var pivot = $Pivot
onready var model = $Pivot/Model
onready var tween = $Tween

func _physics_process(delta):
	if Input.is_action_pressed("roll_left"):
		roll(Vector3.RIGHT)
	elif Input.is_action_pressed("roll_right"):
		roll(Vector3.LEFT)
	elif Input.is_action_pressed("roll_up"):
		roll(Vector3.BACK)
	elif Input.is_action_pressed("roll_down"):
		roll(Vector3.FORWARD)
	
func roll(direction):
	if tween.is_active():
		return
	
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


func _on_tween_step(object, key, elapsed, value):
	pivot.transform = pivot.transform.orthonormalized()
